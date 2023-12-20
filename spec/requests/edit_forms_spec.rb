# frozen_string_literal: true

require "rails_helper"

RSpec.describe "EditForms" do
  describe "GET new_edit_form_path" do

    it_behaves_like "user is not logged in", action: :get, path: :new_edit_form_path
    it_behaves_like "user is not authorised to perform action", action: :get, path: :new_edit_form_path, role: :data_agent

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before { sign_in(user) }

      context "when no matching registration exists" do
        it "redirects to the invalid token error page" do
          get new_edit_form_path("CBDU999999999")

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when the token doesn't match the format" do
        it "redirects to the invalid token error page" do
          get new_edit_form_path("foo")

          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        context "when the given registration is not active" do
          let(:registration) { create(:registration, :pending) }

          it "redirects to the invalid error page" do
            get new_edit_form_path(registration.reg_identifier)

            expect(response).to redirect_to(page_path("invalid"))
          end
        end

        context "when the given registration is active" do
          let(:registration) { create(:registration, :active) }

          it "responds to the GET request with a 200 status code and renders the appropriate template" do
            get new_edit_form_path(registration.reg_identifier)

            expect(response).to render_template("edit_forms/new")
            expect(response).to have_http_status(:ok)
          end

          context "when the registration business type is an old frontend one" do
            let(:registration) { create(:registration, :active, business_type: "publicBody") }

            it "responds to the GET request with a 200 status code and renders the appropriate template" do
              get new_edit_form_path(registration.reg_identifier)

              expect(response).to render_template("edit_forms/new")
              expect(response).to have_http_status(:ok)
            end
          end
        end
      end
    end
  end

  describe "POST edit_forms_path" do

    it_behaves_like "user is not logged in", action: :post, path: :edit_forms_path
    it_behaves_like "user is not authorised to perform action", action: :post, path: :edit_forms_path, role: :data_agent

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      context "when no matching registration exists" do
        it "redirects to the invalid token error page and does not create a new transient registration" do
          original_tr_count = EditRegistration.count

          post edit_forms_path("CBDU99999")

          expect(response).to redirect_to(page_path("invalid"))
          expect(EditRegistration.count).to eq(original_tr_count)
        end
      end

      context "when the token doesn't match the format" do
        it "redirects to the invalid token error page and does not create a new transient registration" do
          original_tr_count = EditRegistration.count

          post edit_forms_path("foo")

          expect(EditRegistration.count).to eq(original_tr_count)
          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        let(:registration) { create(:registration, :active) }

        it "creates a transient registration with correct data, returns a 302 response and redirects to the declaration" do
          expected_tr_count = EditRegistration.count + 1

          post edit_forms_path(registration.reg_identifier)

          transient_registration = EditRegistration.find_by(reg_identifier: registration.reg_identifier)

          expect(expected_tr_count).to eq(EditRegistration.count)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(
            WasteCarriersEngine::Engine.routes.url_helpers.new_declaration_form_path(transient_registration.token)
          )
        end
      end

      context "when a matching edit_registration exists" do
        let!(:edit_registration) { create(:edit_registration) }

        it "does not create a new transient registration, returns a 302 response and redirects to the declaration" do
          expected_tr_count = EditRegistration.count

          post edit_forms_path(edit_registration.reg_identifier)

          expect(expected_tr_count).to eq(EditRegistration.count)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(
            WasteCarriersEngine::Engine.routes.url_helpers.new_declaration_form_path(edit_registration.token)
          )
        end
      end
    end
  end

  describe "edit redirect paths" do
    let(:edit_registration) { create(:edit_registration) }
    let(:token) { edit_registration.token }

    # Rather than heavily test all these near-identical controller actions, we'll just test cbd_type:
    it_behaves_like "user is not logged in", action: :get, path: :cbd_type_edit_forms_path
    it_behaves_like "user is not authorised to perform action", action: :get, path: :cbd_type_edit_forms_path, role: :data_agent

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before { sign_in(user) }

      describe "GET edit_cbd_type" do
        it "redirects to the cbd_type form" do
          get cbd_type_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_cbd_type_form_path(token))
        end
      end

      describe "GET edit_company_name" do
        it "redirects to the company_name form" do
          get company_name_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_company_name_form_path(token))
        end
      end

      describe "POST edit_company_name" do
        it "redirects to the edit form" do
          post WasteCarriersEngine::Engine.routes.url_helpers.company_name_forms_path(token)
          expect(response).to redirect_to Rails.application.routes.url_helpers.new_edit_form_path(token)
        end
      end

      describe "GET edit_company_address" do
        it "redirects to the company postcode form" do
          get company_address_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_company_postcode_form_path(token))
        end
      end

      describe "GET edit_main_people" do
        it "redirects to the main_people form" do
          get main_people_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_main_people_form_path(token))
        end
      end

      describe "GET edit_contact_name" do
        it "redirects to the contact_name form" do
          get contact_name_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_contact_name_form_path(token))
        end
      end

      describe "GET edit_contact_phone" do
        it "redirects to the contact_phone form" do
          get contact_phone_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_contact_phone_form_path(token))
        end
      end

      describe "GET edit_contact_email" do
        it "redirects to the contact_email form" do
          get contact_email_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_contact_email_form_path(token))
        end
      end

      describe "GET edit_contact_address" do
        it "redirects to the contact postcode form" do
          get contact_address_edit_forms_path(token)
          expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_contact_postcode_form_path(token))
        end
      end

      # Rather than heavily test all these near-identical controller actions, we'll just test cbd_type:

      context "when the token is not valid" do
        it "redirects to the invalid token error page and does not create a new transient registration" do
          original_tr_count = EditRegistration.count

          get cbd_type_edit_forms_path("foo")

          expect(EditRegistration.count).to eq(original_tr_count)
          expect(response).to redirect_to(page_path("invalid"))
        end
      end
    end
  end
end
