# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CeaseOrRevokeForms" do
  describe "GET new_cease_or_revoke_form_path" do
    context "when a user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before do
        sign_in(user)
      end

      context "when no matching registration exists" do
        it "redirects to the invalid token error page" do
          get new_cease_or_revoke_form_path("CBDU999999999")

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when the token doesn't match the format" do
        it "redirects to the invalid token error page" do
          get new_cease_or_revoke_form_path("foo")

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        context "when the given registration is not active" do
          let(:registration) { create(:registration, :pending) }

          it "redirects to the page" do
            get new_cease_or_revoke_form_path(registration.reg_identifier)

            expect(response).to redirect_to(page_path("invalid"))
          end
        end

        context "when the given registration is active" do
          let(:registration) { create(:registration, :active) }

          it "responds to the GET request with a 200 status code and renders the appropriate template" do
            get new_cease_or_revoke_form_path(registration.reg_identifier)

            expect(response).to render_template("cease_or_revoke_forms/new")
            expect(response).to have_http_status(:ok)
          end

          context "when an order is in progress" do
            let!(:transient_registration) { create(:ceased_or_revoked_registration, workflow_state: "ceased_or_revoked_confirm_form") }

            context "when the token is a reg_identifier" do
              it "redirects to the correct workflow state form" do
                get new_cease_or_revoke_form_path(transient_registration.registration.reg_identifier)

                expect(response).to redirect_to(new_ceased_or_revoked_confirm_form_path(transient_registration.token))
              end
            end

            context "when the token is a token" do
              it "redirects to the correct workflow state form" do
                get new_cease_or_revoke_form_path(transient_registration.token)

                expect(response).to redirect_to(new_ceased_or_revoked_confirm_form_path(transient_registration.token))
              end
            end
          end
        end
      end
    end

    context "when a user is not signed in" do
      before do
        user = create(:user)
        sign_out(user)
      end

      it "returns a 302 response and redirects to the sign in page" do
        get new_cease_or_revoke_form_path("foo")

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST cease_or_revoke_forms_path" do
    context "when a user is signed in" do
      let(:user) { create(:user, role: "agency_with_refund") }

      before do
        sign_in(user)
      end

      context "when no matching registration exists" do
        it "redirects to the invalid token error page and does not create a new transient registration" do
          original_tr_count = CeasedOrRevokedRegistration.count

          post cease_or_revoke_forms_path("CBDU99999")

          expect(response).to redirect_to(page_path("invalid"))
          expect(CeasedOrRevokedRegistration.count).to eq(original_tr_count)
        end
      end

      context "when the token doesn't match the format" do
        it "redirects to the invalid token error page and does not create a new transient registration" do
          original_tr_count = CeasedOrRevokedRegistration.count

          post cease_or_revoke_forms_path("foo")

          expect(CeasedOrRevokedRegistration.count).to eq(original_tr_count)
          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        let(:registration) { create(:registration, :active) }

        context "when valid params are submitted" do
          let(:valid_params) { { token: registration.reg_identifier, metaData: { status: "REVOKED", revoked_reason: "Some reason" } } }

          it "creates a transient registration with correct data, returns a 302 response and redirects to the ceased_or_revoked_form" do
            expected_tr_count = CeasedOrRevokedRegistration.count + 1

            post cease_or_revoke_forms_path(registration.reg_identifier), params: { cease_or_revoke_form: valid_params }

            transient_registration = CeasedOrRevokedRegistration.find_by(reg_identifier: registration.reg_identifier)

            expect(expected_tr_count).to eq(CeasedOrRevokedRegistration.count)
            expect(transient_registration.metaData.status).to eq("REVOKED")
            expect(transient_registration.metaData.revoked_reason).to eq("Some reason")

            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(new_ceased_or_revoked_confirm_form_path(transient_registration.token))
          end
        end

        context "when invalid params are submitted" do
          let(:invalid_params) { { token: registration.reg_identifier, metaData: {} } }

          it "returns a 200 response and render the new form" do
            post cease_or_revoke_forms_path(registration.reg_identifier), params: { cease_or_revoke_form: invalid_params }

            expect(response).to have_http_status(:ok)
            expect(response).to render_template("cease_or_revoke_forms/new")
          end
        end
      end
    end

    context "when a user is not signed in" do
      let(:registration) { create(:registration) }
      let(:valid_params) { { token: registration.reg_identifier } }

      before do
        user = create(:user)
        sign_out(user)
      end

      it "returns a 302 response, redirects to the login page and does not create a new transient registration" do
        original_tr_count = CeasedOrRevokedRegistration.count

        post cease_or_revoke_forms_path(registration.reg_identifier), params: { renewal_start_form: valid_params }

        expect(response).to redirect_to(new_user_session_path)
        expect(response).to have_http_status(:found)
        expect(CeasedOrRevokedRegistration.count).to eq(original_tr_count)
      end
    end
  end
end
