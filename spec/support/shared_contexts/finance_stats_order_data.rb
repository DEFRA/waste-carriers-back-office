# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.shared_context "Finance stats order data" do

  let(:order_data) do
    [
      { date: 5.months.ago,
        orders: [
          # create one charge_adjust order for STG12, one new registration order with copy cards, etc.
          { "CHARGE_ADJUST": 1200 },
          { "NEW": 10_500, "COPY_CARDS": 1500 },
          { "NEW": 10_500 },
          { "COPY_CARDS": 1500 },
          { "RENEW": 10_000 },
          { "RENEW": 10_000, "COPY_CARDS": 2500 },
          { "EDIT": 2500 },
          { "IR_IMPORT": 9876 }
        ] },
      { date: 4.months.ago,
        orders: [
          { "CHARGE_ADJUST": 1200 },
          { "NEW": 10_500, "COPY_CARDS": 1500 },
          { "NEW": 10_500, "COPY_CARDS": 500 },
          { "NEW": 10_500, "COPY_CARDS": 3500 },
          { "NEW": 10_500 },
          { "COPY_CARDS": 1500 },
          { "RENEW": 10_000 },
          { "RENEW": 10_000, "COPY_CARDS": 2500 },
          { "RENEW": 10_000, "COPY_CARDS": 1500 },
          { "EDIT": 2500 },
          { "EDIT": 2500 }
        ] },
      { date: 3.months.ago,
        orders: [
          { "CHARGE_ADJUST": 9600 },
          { "NEW": 10_500, "COPY_CARDS": 1500 },
          { "NEW": 10_500 },
          { "COPY_CARDS": 1500 },
          { "RENEW": 10_000 },
          { "RENEW": 10_000 },
          { "RENEW": 10_000, "COPY_CARDS": 7500 },
          { "EDIT": 2500 }
        ] }
    ]
  end

  # tally the test data directly to aid comparisons, by totals per month and by type per month
  let(:test_charge_tallies) do
    charges_by_date_by_type = {}
    order_data.each do |date_charge_data|
      date = date_charge_data[:date].strftime("%Y-%m-%d")
      charges_by_date_by_type[date] ||= {}
      date_charge_data[:orders].each do |order|
        order.each do |type_sym, amount|
          type = type_sym.to_s
          charges_by_date_by_type[date] ||= {}
          charges_by_date_by_type[date][type] ||= { count: 0, amount: 0 }
          charges_by_date_by_type[date][type][:count] += 1
          charges_by_date_by_type[date][type][:amount] += amount
        end
      end
    end
    charges_by_date_by_type
  end

  # map the report charge type names to the app charge types for use in specs
  let(:report_charge_type_map) do
    {
      "chargeadjust" => "CHARGE_ADJUST",
      "copycards" => "COPY_CARDS",
      "newreg" => "NEW",
      "renew" => "RENEW",
      "edit" => "EDIT",
      "irimport" => "IR_IMPORT"
    }
  end

  before(:each) do
    # create registrations with order details as above
    order_data.each do |date_set|
      date_set[:orders].each do |order|
        order_items = order.map { |type, amount| build(:order_item, type: type, amount: amount) }
        orders = build_list(:order, 1, date_created: date_set[:date], order_items: order_items)
        create(:registration, finance_details: build(:finance_details, balance: 0, orders: orders))
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength