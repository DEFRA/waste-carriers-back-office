# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.shared_context "with finance stats payment data" do

  def an_amount
    Faker::Number.number(digits: 4)
  end

  let(:payment_data) do
    [
      { date: 5.months.ago,
        payments: {
          "BANKTRANSFER" => [an_amount, an_amount],
          "CHEQUE" => [an_amount],
          "CASH" => [an_amount, an_amount, an_amount, an_amount],
          "POSTALORDER" => [an_amount],
          "WORLDPAY" => [an_amount, an_amount, an_amount]
        } },
      # ensure there are values for multiple days in at least one month
      { date: 5.months.ago + 1.day,
        payments: {
          "BANKTRANSFER" => [an_amount, an_amount, an_amount],
          "WORLDPAY" => [an_amount]
        } },
      { date: 4.months.ago - 1.day,
        payments: {
          "BANKTRANSFER" => [an_amount, an_amount, an_amount],
          "WORLDPAY" => [an_amount]
        } },
      { date: 4.months.ago,
        payments: {
          "POSTALORDER" => [an_amount, an_amount],
          "BANKTRANSFER" => [an_amount, an_amount, an_amount],
          "WORLDPAY" => [an_amount]
        } },
      { date: 3.months.ago,
        payments: {
          "POSTALORDER" => [an_amount, an_amount],
          "WORLDPAY" => [an_amount, an_amount, an_amount, an_amount],
          "WORLDPAY_MISSED" => [an_amount, an_amount]
        } }
    ]
  end

  # tally the test data directly to aid comparisons, by date and by type.
  let(:test_payment_tallies) do
    payments_by_date = {}
    payment_data.each do |date_payment_data|
      yymm = date_payment_data[:date].strftime("%Y-%m")
      yymmdd = date_payment_data[:date].strftime("%Y-%m-%d")
      payments_by_date[yymm] ||= { totals: { count: 0, amount: 0 } }
      payments_by_date[yymmdd] ||= { totals: { count: 0, amount: 0 } }
      date_payment_data[:payments].each do |type, amounts|
        amounts.each do |amount|
          payments_by_date[yymm][type] ||= { count: 0, amount: 0 }
          payments_by_date[yymmdd][type] ||= { count: 0, amount: 0 }
          payments_by_date[yymm][type][:count] += 1
          payments_by_date[yymmdd][type][:count] += 1
          payments_by_date[yymm][type][:amount] += amount
          payments_by_date[yymmdd][type][:amount] += amount
          payments_by_date[yymm][:totals][:count] += 1
          payments_by_date[yymmdd][:totals][:count] += 1
          payments_by_date[yymm][:totals][:amount] += amount
          payments_by_date[yymmdd][:totals][:amount] += amount
        end
      end
    end
    payments_by_date
  end

  # map the report payment type names to the app payment types for use in specs
  let(:report_payment_type_map) do
    {
      "banktransfer" => "BANKTRANSFER",
      "cheque" => "CHEQUE",
      "cash" => "CASH",
      "postalorder" => "POSTALORDER",
      "worldpay" => "WORLDPAY",
      "worldpaymissed" => "WORLDPAY_MISSED"
    }
  end

  # map the payment types to the payment factory trait names for local use
  trait_type_map = {
    "BANKTRANSFER" => :bank_transfer,
    "CHEQUE" => :cheque,
    "CASH" => :cash,
    "POSTALORDER" => :postal_order,
    "WORLDPAY" => :worldpay,
    "WORLDPAY_MISSED" => :worldpay_missed
  }.freeze

  before do
    # create registrations with payment details as above
    payment_data.each do |date_set|
      date_set[:payments].each do |type, amounts|
        amounts.each do |amount|
          create(:registration, finance_details:
            build(:finance_details, :has_single_payment,
                  payment_type: trait_type_map[type],
                  payment_amount: amount,
                  payment_date_entered: date_set[:date]))
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
