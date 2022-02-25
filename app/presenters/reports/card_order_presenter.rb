# frozen_string_literal: true

module Reports
  class CardOrderPresenter < WasteCarriersEngine::BasePresenter

    DATE_FORMAT = "%d/%m/%Y"

    def initialize(model)
      @order_item_log = model
      @registration = WasteCarriersEngine::Registration.find(model.registration_id)

      # Address fields need to be presented as a set but may be queried individually,
      # so prepare them once for lookup on initialiation
      @registered_address = present_address(
        @registration.addresses.select { |a| a.addressType == "REGISTERED" }[0],
        "registered",
        @registration.company_name
      )
      @contact_address = present_address(
        @registration.addresses.select { |a| a.addressType == "POSTAL" }[0],
        "contact",
        @registration.company_name
      )

      super(model)
    end

    def reg_identifier
      @registration.reg_identifier
    end

    def date_of_issue
      @order_item_log.activated_at.strftime(DATE_FORMAT)
    end

    def carrier_name
      case @registration.tier
      when "LOWER"
        @registration.company_name
      when "UPPER"
        case @registration.business_type
        when "soleTrader"
          "#{@registration.key_people[0].first_name} #{@registration.key_people[0].last_name}"
        else
          @registration.company_name
        end
      else
        ""
      end
    end

    def company_name
      @registration.company_name
    end

    def registration_type
      @registration.registration_type
    end

    def registration_date
      @registration.metaData.dateRegistered.present? ? @registration.metaData.dateRegistered.strftime(DATE_FORMAT) : ""
    end

    def expires_on
      @registration.expires_on.present? ? @registration.expires_on.strftime(DATE_FORMAT) : ""
    end

    def contact_phone_number
      "=\"#{@registration.phone_number}\""
    end

    # Define address-level fields dynamically
    address_keys = %w[line_1 line_2 line_3 line_4 line_5 line_6 town_city postcode country].freeze
    address_keys.each do |key|
      define_method("registered_address_#{key}".to_sym) { @registered_address["registered_address_#{key}".to_sym] }
    end
    address_keys.each do |key|
      define_method("contact_address_#{key}".to_sym) { @contact_address["contact_address_#{key}".to_sym] }
    end

    # Map an address from WCR database form to the presentation form.
    def present_address(address, prefix, company_name)
      return "" unless address

      # These fields if present are to map to lines 1-5 in the output,
      # with any blanks between lines removed.
      address_values = [address.houseNumber,
                        # Skip address line 1 if it matches the carrier name.
                        address.addressLine1 == company_name ? "" : address.addressLine1,
                        address.addressLine2,
                        address.addressLine3,
                        address.addressLine4].reject(&:blank?)
      address_hash = {}

      address_values.each_with_index do |value, index|
        address_hash["#{prefix}_address_line_#{index + 1}".to_sym] = value
      end

      # Pad out the address lines to the required six with blanks
      (address_hash.keys.length..5).each do |n|
        address_hash["#{prefix}_address_line_#{n + 1}".to_sym] = nil
      end

      address_hash.merge!(
        "#{prefix}_address_town_city": address.townCity,
        "#{prefix}_address_postcode": address.postcode,
        "#{prefix}_address_country": address.country
      )

      address_hash
    end
  end
end
