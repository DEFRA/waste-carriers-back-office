# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CeasedOrRevokedConfirmForms" do
  describe "GET new_ceased_or_revoked_confirm_form_path" do
    context "when a user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before do
        sign_in(user)
      end

      context "when no matching registration exists" do
        it "redirects to the invalid token error page" do
          get new_ceased_or_revoked_confirm_form_path("CBDU999999999")
          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        let(:transient_registration) do
          create(
            :ceased_or_revoked_registration,
            workflow_state: "ceased_or_revoked_confirm_form",
            metaData: {
              status: "REVOKED"
            }
          )
        end

        it "renders the appropriate template and responds with a 200 status code" do
          get new_ceased_or_revoked_confirm_form_path(transient_registration.token)

          expect(response).to render_template("ceased_or_revoked_confirm_forms/new")
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "when a user is not signed in" do
      before do
        user = create(:user)
        sign_out(user)
      end

      it "returns a 302 response" do
        get new_ceased_or_revoked_confirm_form_path("foo")

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(page_path("invalid"))
      end
    end
  end

  describe "POST ceased_or_revoked_confirm_forms_path" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when a valid transient registration exists" do
        let(:transient_registration) do
          create(
            :ceased_or_revoked_registration,
            workflow_state: "ceased_or_revoked_confirm_form",
            metaData: {
              status: "REVOKED",
              revokedReason: "Revoked Reason"
            }
          )
        end

        context "when the workflow_state is correct" do
          before { allow(WasteCarriersEngine.configuration).to receive(:host_is_back_office?).and_return(true) }

          it "deletes the transient object, copy data to the registration, redirects to the main dashboard page" do
            registration = transient_registration.registration

            post ceased_or_revoked_confirm_forms_path(transient_registration.token)

            registration.reload

            expect(WasteCarriersEngine::TransientRegistration.count).to eq(0)
            expect(registration.metaData.status).to eq("REVOKED")
            expect(registration.metaData.revokedReason).to eq("Revoked Reason")
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to("/bo")
          end
        end
      end
    end
  end
end
