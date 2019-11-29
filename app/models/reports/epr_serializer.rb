# frozen_string_literal: true

module Reports
  class EprSerializer < BaseSerializer
    # TODO
    ATTRIBUTES = [:reg_identifier].freeze

    private

    def registrations_scope
      # TODO
      ::WasteCarriersEngine::Registration.all
    end

    def parse_registration(registration)
      ATTRIBUTES.map do |attribute|
        # TODO
        # presenter = ExemptionEprReportPresenter.new(registration)
        # presenter.public_send(attribute)
        registration.public_send(attribute)
      end
    end
  end
end
