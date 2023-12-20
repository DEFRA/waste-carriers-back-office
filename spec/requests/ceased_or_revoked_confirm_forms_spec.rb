# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CeasedOrRevokedConfirmForms" do
  describe "GET new_ceased_or_revoked_confirm_form_path" do

    it_behaves_like "user is not logged in", action: :get, path: :new_ceased_or_revoked_confirm_form_path
    it_behaves_like "user is not authorised to perform action", action: :get, path: :new_ceased_or_revoked_confirm_form_path, role: :finance

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before { sign_in(user) }

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
  end

  describe "POST ceased_or_revoked_confirm_forms_path" do

    it_behaves_like "user is not logged in", action: :post, path: :cease_or_revoke_forms_path
    it_behaves_like "user is not authorised to perform action", action: :post, path: :new_cease_or_revoke_form_path, role: :finance

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before { sign_in(user) }

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

          it "deletes the transient object" do
            transient_registration # instantiate

            expect { post ceased_or_revoked_confirm_forms_path(transient_registration.token) }
              .to change(WasteCarriersEngine::TransientRegistration, :count).by(-1)
          end

          it "copies data to the registration" do
            registration = transient_registration.registration

            post ceased_or_revoked_confirm_forms_path(transient_registration.token)

            registration.reload

            aggregate_failures do
              expect(registration.metaData.status).to eq("REVOKED")
              expect(registration.metaData.revokedReason).to eq("Revoked Reason")
            end
          end

          it "redirects to the main dashboard page" do
            post ceased_or_revoked_confirm_forms_path(transient_registration.token)

            aggregate_failures do
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to("/bo")
            end
          end
        end
      end
    end
  end
end
