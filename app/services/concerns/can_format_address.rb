# frozen_string_literal: true

module CanFormatAddress
  private

  # So we can use displayable_address()
  include ::WasteCarriersEngine::ApplicationHelper

  def address_lines
    address_values = [
      @registration.contact_name,
      displayable_address(@registration.contact_address)
    ].flatten

    address_hash = {}

    address_values.each_with_index do |value, index|
      line_number = index + 1
      address_hash["address_line_#{line_number}".to_sym] = value
    end

    address_hash
  end
end
