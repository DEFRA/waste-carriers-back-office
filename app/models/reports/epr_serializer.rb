# frozen_string_literal: true

module Reports
  class EprSerializer < BaseSerializer
    ATTRIBUTES = [].freeze # TODO

    private

    def registration_exemptions_scope
      # TODO
      # WasteExemptionsEngine::RegistrationExemption.all_active_exemptions
    end

    def parse_registration_exemption(_registration_exemption)
      ATTRIBUTES.map do |attribute|
        # TODO
        # presenter = ExemptionEprReportPresenter.new(registration_exemption)
        # presenter.public_send(attribute)
      end
    end
  end
end
