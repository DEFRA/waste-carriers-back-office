# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Assisted Digital Forms", type: :request do
  let(:registration) { create(:registration, :expires_soon) }

  describe "GET /bo/:reg_identifier/renew" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }

      before do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/#{registration.reg_identifier}/renew"

        expect(response).to render_template(:new)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/#{registration.reg_identifier}/renew"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/:reg_identifier/renew" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }

      before do
        sign_in(user)
      end

      it "creates a new transient registration" do
        expected_tr_count = WasteCarriersEngine::RenewingRegistration.count + 1

        post "/bo/#{registration.reg_identifier}/renew"

        updated_tr_count = WasteCarriersEngine::RenewingRegistration.count

        expect(expected_tr_count).to eq(updated_tr_count)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }

      before do
        sign_in(user)
      end

      it "does not create a new transient registration and redirects to the permissions error page" do
        expected_tr_count = WasteCarriersEngine::RenewingRegistration.count

        post "/bo/#{registration.reg_identifier}/renew"

        updated_tr_count = WasteCarriersEngine::RenewingRegistration.count

        expect(expected_tr_count).to eq(updated_tr_count)
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end
end
