# frozen_string_literal: true

class ClearNcccContactEmailsService < WasteCarriersEngine::BaseService

  # Include the correct NCCC email address prefixes and all known variants
  PREFIX_KEYWORDS = %w[
    nccc
    nccc-carrierbroker
    ncc
    carrier
    ccscoaching
    broker broke bokrer borker brocker
    exemptions
  ].freeze

  # Include the correct NCCC email address domain and all known variants
  # Allow for variants consisting of or ending in "agency.gov.uk", "-agency.gov.uk" and "-agency-gov.uk"
  GOV_UK_DOMAINS = %w[
    environment-agency.gov.uk
    .*[ment|emnt|mnet|mental|environ]?[-\.]?agency\.gov\.uk
  ].freeze

  def run
    PREFIX_KEYWORDS.each do |keyword|
      GOV_UK_DOMAINS.each do |domain|
        matching_registrations = registrations_with_contact_email(keyword, domain)
        next unless matching_registrations.any?

        Rails.logger.info "Clearing NCCC contact email addresses: #{matching_registrations.pluck(:contact_email)}"
        matching_registrations.update_all(contact_email: nil)
      end
    end
  end

  private

  def registrations_with_contact_email(keyword, domain)
    # Registrations which include the keyword before the @, with or without additional characters, and the domain
    WasteCarriersEngine::Registration.where(contact_email: /.*#{keyword}.*@#{domain}/i)
  end
end
