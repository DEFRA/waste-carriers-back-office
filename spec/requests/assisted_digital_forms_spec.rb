# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Assisted Digital Forms", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /bo/renew/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/renew/#{registration.reg_identifier}"
        expect(response).to render_template(:new)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/renew/#{registration.reg_identifier}"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end

  describe "POST /bo/renew/:reg_identifier" do
    let(:params) do
      { reg_identifier: registration.reg_identifier }
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "creates a new transient registration" do
        expected_tr_count = WasteCarriersEngine::TransientRegistration.count + 1
        post "/bo/renew/", renewal_start_form: params
        updated_tr_count = WasteCarriersEngine::TransientRegistration.count

        expect(expected_tr_count).to eq(updated_tr_count)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "does not create a new transient registration" do
        expected_tr_count = WasteCarriersEngine::TransientRegistration.count
        post "/bo/renew/", renewal_start_form: params
        updated_tr_count = WasteCarriersEngine::TransientRegistration.count

        expect(expected_tr_count).to eq(updated_tr_count)
      end

      it "redirects to the permissions error page" do
        post "/bo/renew/", renewal_start_form: params
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end
end
