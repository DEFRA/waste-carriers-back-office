# frozen_string_literal: true

class BaseRegistrationPresenter < WasteCarriersEngine::BasePresenter
  def displayable_location
    location = show_translation_or_filler(:location)

    I18n.t(".shared.registrations.show.business_information.labels.location", location: location)
  end

  private

  def show_translation_or_filler(attribute)
    if send(attribute).present?
      I18n.t(".shared.registrations.show.attributes.#{attribute}.#{send(attribute)}")
    else
      I18n.t(".shared.registrations.show.filler")
    end
  end
end
