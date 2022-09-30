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

      monthly_post_process

      @results.sort_by { |res| res[:period] }
    end

    def entry_period(result)
      if @daily
        format("%<year>04i%<month>02i%<day>02i", year: result[:year], month: result[:month], day: result[:day])
      else
        format("%<year>04i%<month>02i", year: result[:year], month: result[:month])
      end
    end

    def expiry_period(result)
      expiry_date = Date.new(result[:year], result[:month], 1) + 36.months
      format("%<year>04i%<month>02i", year: expiry_date.year, month: expiry_date.month)
    end

    # rubocop:disable Metrics/MethodLength
    def results_entry(result)
      entry = find_matching_result(result)
      if entry.blank?
        entry = ActiveSupport::HashWithIndifferentAccess.new(
          period: entry_period(result),
          year: result[:year],
          month: result[:month],
          day: (result[:day] if @daily),
          balance: 0,
          renewals_due: (0 unless @daily),
          renewal_percent: (0 unless @daily),
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
        ).compact
        @results << entry
      end

      entry
    end
    # rubocop:enable Metrics/MethodLength

    def find_matching_result(candidate)
      if @daily
        @results.select { |result| result.slice(:year, :month, :day) == candidate.slice(:year, :month, :day) }.first
      else
        @results.select { |result| result.slice(:year, :month) == candidate.slice(:year, :month) }.first
      end
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

    # If there is an entry for this month plus 36 months, populate renewals_due on it
    def monthly_post_process
      @results.each do |result|
        expiry_result = @results.select { |r| r[:period] == expiry_period(result) }.first
        next if expiry_result.blank?

        expiry_result[:renewals_due] = result[:charges][:newreg][:count] + result[:charges][:renew][:count]
        expiry_result[:renewal_percent] = if expiry_result[:renewals_due].positive?
                                            expiry_result[:charges][:renew][:count].to_f / expiry_result[:renewals_due]
                                          else
                                            0.0
                                          end
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
