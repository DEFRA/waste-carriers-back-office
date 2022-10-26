# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Convictions" do
  let(:registration) { create(:registration, :requires_conviction_check) }
  let(:transient_registration) { create(:renewing_registration, :requires_conviction_check) }

  describe "/bo/registrations/:reg_identifier/convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "renders the index template, returns a 200 response, and includes the reg identifier" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/transient-registrations/:reg_identifier/convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "renders the index template, returns a 200 response, and includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/registrations/:registration_reg_identifier/convictions/begin-checks" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "updates the status of the conviction_sign_off and redirects to the convictions page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/begin-checks"

        expect(registration.reload.conviction_sign_offs.first.workflow_state).to eq("checks_in_progress")
        expect(response).to redirect_to(convictions_path)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/begin-checks"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/registrations/#{registration.reg_identifier}/convictions/begin-checks"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/transient-registrations/:transient_registration_reg_identifier/convictions/begin-checks" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "updates the status of the conviction_sign_off and redirects to the convictions page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/begin-checks"

        expect(transient_registration.reload.conviction_sign_offs.first.workflow_state).to eq("checks_in_progress")
        expect(response).to redirect_to(convictions_path)
      end
    end
  end

  context "when a non-agency user is signed in" do
    let(:user) { create(:user, :finance) }

    before do
      sign_in(user)
    end

    it "redirects to the permissions error page" do
      get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/begin-checks"

      expect(response).to redirect_to("/bo/pages/permission")
    end
  end

  context "when a user is not signed in" do
    it "redirects to the sign-in page" do
      get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/begin-checks"

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
