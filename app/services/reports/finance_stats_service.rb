# frozen_string_literal: true

module Reports
  # rubocop:disable Metrics/ClassLength
  class FinanceStatsService < ::WasteCarriersEngine::BaseService

    def initialize(granularity)
      case granularity
      when :ddmmyyyy
        @daily = true
      when :mmyyyy
        @daily = false
      else
        raise StandardError, "Unrecognised granularity specifier #{granularity}"
      end

      @granularity = granularity

      super()
    end

    def run
      @results = []

      PaymentsByTypeService.new(@granularity).run.each do |result|
        entry = results_entry(result)
        update_entry(entry, result)
      end

      ChargesByTypeService.new(@granularity).run.each do |result|
        entry = results_entry(result)
        update_entry(entry, result)
      end

      @results.sort_by { |res| res[:period] }
    end

    def entry_period(result)
      if @daily
        format("%<year>04i%<month>02i%<day>02i", year: result[:year], month: result[:month], day: result[:day])
      else
        format("%<year>04i%<month>02i", year: result[:year], month: result[:month])
      end
    end

    # rubocop:disable Metrics/MethodLength
    def results_entry(result)
      entry = find_matching_result(result)
      unless entry.present?
        entry = {
          period: entry_period(result),
          year: result[:year],
          month: result[:month],
          day: (result[:day] if @daily),
          balance: 0,
          payments: {
            count: 0,
            balance: 0,
            cash: { count: 0, total: 0 },
            reversal: { count: 0, total: 0 },
            postalorder: { count: 0, total: 0 },
            refund: { count: 0, total: 0 },
            worldpay: { count: 0, total: 0 },
            worldpaymissed: { count: 0, total: 0 },
            cheque: { count: 0, total: 0 },
            banktransfer: { count: 0, total: 0 },
            writeoffsmall: { count: 0, total: 0 },
            writeofflarge: { count: 0, total: 0 }
          },
          charges: {
            count: 0,
            balance: 0,
            chargeadjust: { count: 0, total: 0 },
            copycards: { count: 0, total: 0 },
            newreg: { count: 0, total: 0 },
            renew: { count: 0, total: 0 },
            edit: { count: 0, total: 0 },
            irimport: { count: 0, total: 0 }
          }
        }.compact
        @results << entry
      end

      entry
    end
    # rubocop:enable Metrics/MethodLength

    def find_matching_result(candidate)
      @results.select { |result| result[:year] == candidate[:year] && result[:month] == candidate[:month] }.first
    end

    def update_balance(entry, result)
      if result[:resultType] == "charge"
        entry[:balance] += result[:total]
      else
        entry[:balance] -= result[:total]
      end
    end

    def update_payment_type(entry, result)
      result_type = result[:type].to_sym
      entry[:payments][result_type][:count] += result[:count]
      entry[:payments][result_type][:total] += result[:total]
    end

    def update_payments(entry, result)
      entry[:payments][:count] += result[:count]
      entry[:payments][:balance] += result[:total]

      update_payment_type(entry, result)
    end

    def update_charge_type(entry, result)
      result_type = result[:type].to_sym
      entry[:charges][result_type][:count] += result[:count]
      entry[:charges][result_type][:total] += result[:total]
    end

    def update_charges(entry, result)
      entry[:charges][:count] += result[:count]
      entry[:charges][:balance] += result[:total]

      update_charge_type(entry, result)
    end

    def update_entry(entry, result)
      update_balance(entry, result)

      update_payments(entry, result) if result[:resultType] == "pay"
      update_charges(entry, result) if result[:resultType] == "charge"
    end
  end
  # rubocop:enable Metrics/ClassLength
end
