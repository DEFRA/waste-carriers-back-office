# frozen_string_literal: true

require "notifications/client"

class NotifyRenewalLetterService < ::WasteCarriersEngine::BaseService
  # So we can use displayable_address()
  include ::WasteCarriersEngine::ApplicationHelper

  def run(registration:)
    @registration = NotifyRenewalLetterPresenter.new(registration)

    client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)

    client.send_letter(template_id: template,
                       personalisation: personalisation)
  end

  private

  def template
    "1b56d3a7-f7fd-414d-a3ba-2b50f627cf40"
  end

  def personalisation
    {
      contact_name: @registration.contact_name,
      expiry_date: @registration.expiry_date,
      reg_identifier: @registration.reg_identifier,
      registration_cost: @registration.registration_cost,
      renewal_cost: @registration.renewal_cost,
      renewal_url: @registration.renewal_url
    }.merge(address_lines)
  end

  def address_lines
    address_values = [
      @registration.contact_name,
      displayable_address(@registration.contact_address)
    ].flatten

    address_hash = {}

    address_values.each_with_index do |value, index|
      line_number = index + 1
      address_hash["address_line_#{line_number}"] = value
    end

    address_hash
  end
end
