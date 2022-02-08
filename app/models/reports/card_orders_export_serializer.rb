# frozen_string_literal: true

module Reports
  class CardOrdersExportSerializer < BaseSerializer
    ATTRIBUTES = {
      reg_identifier: "Registration Number",
      date_of_issue: "Date of Issue",
      carrier_name: "Name of Registered Carrier",
      company_name: "Business Name",
      registered_address_line_1: "Registered Address Line 1",
      registered_address_line_2: "Registered Address Line 2",
      registered_address_line_3: "Registered Address Line 3",
      registered_address_line_4: "Registered Address Line 4",
      registered_address_line_5: "Registered Address Line 5",
      registered_address_line_6: "Registered Address Line 6",
      registered_address_town_city: "Registered Town City",
      registered_address_postcode: "Registered Postcode",
      registered_address_country: "Registered Country",
      contact_phone_number: "Contact Phone Number",
      registration_date: "Registration Date",
      expires_on: "Expiry Date",
      registration_type: "Registration Type",
      contact_address_line_1: "Contact Address Line1",
      contact_address_line_2: "Contact Address Line2",
      contact_address_line_3: "Contact Address Line3",
      contact_address_line_4: "Contact Address Line4",
      contact_address_line_5: "Contact Address Line5",
      contact_address_line_6: "Contact Address Line6",
      contact_address_town_city: "Contact Town City",
      contact_address_postcode: "Contact Postcode",
      contact_address_country: "Contact Country"
    }.freeze

    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time = end_time
      super()
    end

    # Let the caller decide when it's ok to mark the documents as successfully exported
    def mark_exported
      @order_item_logs.update_all(exported: true)
    end

    private

    def scope
      @order_item_logs = WasteCarriersEngine::OrderItemLog.where(
        exported: false,
        type: "COPY_CARD",
        activated_at: { "$gte": @start_time, "$lt": @end_time }
      )

      # Expand the results to one row per card
      @order_item_logs.map { |oil| Array.new(oil.quantity, oil) }.flatten
    end

    def parse_object(order_item_log)
      presenter = CardOrdersExportPresenter.new(order_item_log)
      ATTRIBUTES.map do |key, _value|
        presenter.public_send(key)
      end
    end
  end
end
