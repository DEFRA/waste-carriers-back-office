# frozen_string_literal: true

module Reports
  class PaymentsByTypeService < ::WasteCarriersEngine::BaseService
    # This service encapsulates an aggregation query originally created in JavaScript for use outside the app.
    # This initial implementation uses the original query for consistency, with no optimisatons.
    # TODO: Investigate whether the aggregation can be simplified, e.g.
    #       - Replace multiple identical group stages within facets with a single group operation
    #       - Use $addFields instead of using $project with "some_field: 1"
    # TODO: Investigate whether the aggregation is logically aligned with the equivalent aggregation for charges.

    # Track whether the pipeline needs daily granularity
    def initialize(granularity)
      case granularity
      when :ddmmyyyy
        @daily = true
      when :mmyyyy
        @daily = false
      else
        raise StandardError, "Unrecognised granularity specifier #{granularity}"
      end

      super()
    end

    # rubocop:disable Metrics/MethodLength
    def run
      WasteCarriersEngine::Registration.collection.aggregate(
        [
          { "$match": {
            "$and": [
              { 'financeDetails.payments': { "$exists": true } },
              # We are only interested in completed registrations
              { 'metaData.status': { "$ne": "PENDING" } },
              # Ignore a large volume of imported IR registrations
              { 'metaData.anotherString': { "$ne": "Imported-from-IR" } }
            ]
          } },
          { "$project": {
            regIdentifier: 1,
            payment: "$financeDetails.payments"
          } },
          { "$unwind": { path: "$payment" } },
          { "$project": {
            regIdentifier: 1,
            day: ({ "$dayOfMonth": "$payment.dateEntered" } if @daily),
            month: { "$month": "$payment.dateEntered" },
            year: { "$year": "$payment.dateEntered" },
            paymentType: "$payment.paymentType",
            paymentAmount: "$payment.amount"
          }.compact },
          { "$facet": {
            cash: payment_type_facet_pipeline("CASH", "cash"),
            reversal: payment_type_facet_pipeline("REVERSAL", "reversal"),
            postalorder: payment_type_facet_pipeline("POSTALORDER", "postalorder"),
            refund: payment_type_facet_pipeline("REFUND", "refund"),
            worldpay: payment_type_facet_pipeline("WORLDPAY", "worldpay"),
            worldpayMissed: payment_type_facet_pipeline("WORLDPAY_MISSED", "worldpaymissed"),
            cheque: payment_type_facet_pipeline("CHEQUE", "cheque"),
            banktransfer: payment_type_facet_pipeline("BANKTRANSFER", "banktransfer"),
            writeoffsmall: payment_type_facet_pipeline("WRITEOFFSMALL", "writeoffsmall"),
            writeofflarge: payment_type_facet_pipeline("WRITEOFFLARGE", "writeofflarge")
          } },
          {
            "$project": {
              results: {
                "$setUnion": [
                  "$cash",
                  "$reversal",
                  "$postalorder",
                  "$refund",
                  "$worldpay",
                  "$worldpayMissed",
                  "$cheque",
                  "$banktransfer",
                  "$writeoffsmall",
                  "$writeofflarge"
                ]
              }
            }
          },
          { "$unwind": "$results" },
          { "$replaceRoot": { newRoot: "$results" } }
        ]
      )
    end
    # rubocop:enable Metrics/MethodLength

    private

    def payment_type_facet_pipeline(db_type, report_type)
      [
        { "$match": { paymentType: db_type } },
        { "$group": group_payment_type },
        { "$project": project_payment_type(report_type) }
      ]
    end

    def group_payment_type
      {
        _id: { year: "$year", month: "$month", day: ("$day" if @daily) }.compact,
        count: { "$sum": 1 },
        total: { "$sum": "$paymentAmount" }
      }
    end

    def project_payment_type(payment_type)
      {
        _id: 0,
        year: "$_id.year",
        month: "$_id.month",
        day: ("$_id.day" if @daily),
        count: 1,
        total: 1,
        resultType: "pay",
        type: payment_type
      }.compact
    end
  end
end
