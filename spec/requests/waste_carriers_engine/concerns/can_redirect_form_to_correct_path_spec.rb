# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine

  RSpec.describe CanRedirectFormToCorrectPath do

    before { sign_in create(:user, role: :agency) }

    context "with an engine route with a plural route name" do
      let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_start_form") }

      it "redirects to the engine route" do
        get WasteCarriersEngine::Engine.routes.url_helpers.new_location_form_path(transient_registration.token)

        expect(response).to redirect_to WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(transient_registration.token)
      end
    end

    context "with an engine route with a new_ singular route name" do
      let(:transient_registration) { create(:renewing_registration, workflow_state: "registration_received_pending_payment_form") }

      it "redirects to the engine route" do
        get WasteCarriersEngine::Engine.routes.url_helpers.new_location_form_path(transient_registration.token)

        expect(response).to redirect_to WasteCarriersEngine::Engine.routes.url_helpers
                                                                   .new_registration_received_pending_payment_form_path(transient_registration.token)
      end
    end

    context "with a non-engine route" do
      let(:registration) { create(:registration, :active) }

      it "redirects to the correct route" do
        post edit_forms_path(registration.reg_identifier)

        transient_registration = EditRegistration.find_by(reg_identifier: registration.reg_identifier)

        expect(response).to redirect_to(
          WasteCarriersEngine::Engine.routes.url_helpers.new_declaration_form_path(transient_registration.token)
        )
      end
    end
  end
end
