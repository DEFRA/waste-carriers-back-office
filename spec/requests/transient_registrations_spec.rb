# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TransientRegistration" do
  describe "GET delete_transient_registration_path" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when a valid transient registration exists" do
        it "deletes the transient registration, returns a 302 status and redirects to the registration page" do
          transient_registration = create(:renewing_registration)
          expected_count = WasteCarriersEngine::TransientRegistration.count - 1
          redirect_path = registration_path(
            reg_identifier: transient_registration.reg_identifier
          )

          get delete_transient_registration_path(transient_registration[:token])

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(redirect_path)
          expect(WasteCarriersEngine::TransientRegistration.count).to eq(expected_count)
        end
      end
    end

    context "when a valid user is not signed in" do
      it "returns a 302 status and redirects to the login page" do
        get delete_transient_registration_path("foo")

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to("/bo/users/sign_in")
      end
    end
  end
end
