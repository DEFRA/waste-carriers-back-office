# frozen_string_literal: true

module Reports
  # rubocop:disable Metrics/ClassLength
  class ChargesByTypeService < ::WasteCarriersEngine::BaseService
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
      # This definition is to avoid a SonarCloud complaint, it doesn't really help readability.
      order_date_key = "$orderDate"

      WasteCarriersEngine::Registration.collection.aggregate(
        [
          { "$match": {
            "$and": [
              { 'financeDetails.orders': { "$exists": true } },
              # We are only interested in completed registrations
              { 'metaData.status': { "$ne": "PENDING" } },
              # Ignore a large volume of imported IR registrations
              { 'metaData.anotherString': { "$ne": "Imported-from-IR" } }
            ]
          } },
          { "$project": {
            regIdentifier: 1,
            dateRegistered: "$metaData.dateRegistered",
            order: "$financeDetails.orders"
          } },
          { "$unwind": { path: "$order" } },
          { "$project": {
            regIdentifier: 1,
            orderDate: {
              "$ifNull": [
                "$order.dateCreated",
                { "$ifNull": [
                  "$dateRegistered",
                  Date.parse("1900-01-01T00:00:00Z")
                ] }
              ]
            },
            orderItem: "$order.orderItems"
          } },
          { "$unwind": { path: "$orderItem" } },
          { "$project": {
            regIdentifier: 1,
            day: ({ "$dayOfMonth": order_date_key } if @daily),
            month: { "$month": order_date_key },
            year: { "$year": order_date_key },
            orderType: "$orderItem.type",
            orderAmount: "$orderItem.amount"
          }.compact },
          { "$facet": {
            chargeadjust: order_type_facet_pipeline("CHARGE_ADJUST", "chargeadjust"),
            copycards: order_type_facet_pipeline("COPY_CARDS", "copycards"),
            newreg: order_type_facet_pipeline("NEW", "newreg"),
            renew: order_type_facet_pipeline("RENEW", "renew"),
            edit: order_type_facet_pipeline("EDIT", "edit"),
            irimport: order_type_facet_pipeline("IR_IMPORT", "irimport")
          } },
          { "$project": {
            results: {
              "$setUnion": [
                "$chargeadjust",
                "$copycards",
                "$newreg",
                "$renew",
                "$edit",
                "$irimport"
              ]
            }
          } },
          { "$unwind": "$results" },
          { "$replaceRoot": { newRoot: "$results" } }
        ]
      )
    end
    # rubocop:enable Metrics/MethodLength

    private

    def order_type_facet_pipeline(db_type, report_type)
      [
        { "$match": { orderType: db_type } },
        { "$group": group_charge_type },
        { "$project": project_charge_type(report_type) }
      ]
    end

    def group_charge_type
      {
        _id: { year: "$year", month: "$month", day: ("$day" if @daily) }.compact,
        count: { "$sum": 1 },
        total: { "$sum": "$orderAmount" }
      }
    end

    def project_charge_type(charge_type)
      {
        _id: 0,
        year: "$_id.year",
        month: "$_id.month",
        day: ("$_id.day" if @daily),
        count: 1,
        total: 1,
        resultType: "charge",
        type: charge_type
      }.compact
    end
  end
  # rubocop:enable Metrics/ClassLength

end
