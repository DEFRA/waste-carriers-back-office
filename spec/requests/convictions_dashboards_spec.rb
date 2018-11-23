# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionsDashboards", type: :request do
  describe "/bo/convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/convictions"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/bo/convictions"
        expect(response).to have_http_status(200)
      end

      it "links to renewals which require a convictions check" do
        last_modified_renewal = create(:transient_registration, :requires_conviction_check)
        link_to_renewal = transient_registration_path(last_modified_renewal.reg_identifier)

        get "/bo/convictions"
        expect(response.body).to include(link_to_renewal)
      end

      it "does not link to renewals which don't require a convictions check" do
        last_modified_renewal = create(:transient_registration)
        link_to_renewal = transient_registration_path(last_modified_renewal.reg_identifier)

        get "/bo/convictions"
        expect(response.body).to_not include(link_to_renewal)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/convictions"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/convictions/possible-matches" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the possible_matches template" do
        get "/bo/convictions/possible-matches"
        expect(response).to render_template(:possible_matches)
      end

      it "returns a 200 response" do
        get "/bo/convictions/possible-matches"
        expect(response).to have_http_status(200)
      end

      it "links to renewals which require an initial convictions check" do
        last_modified_renewal = create(:transient_registration, :requires_conviction_check)
        link_to_renewal = transient_registration_path(last_modified_renewal.reg_identifier)

        get "/bo/convictions/possible-matches"
        expect(response.body).to include(link_to_renewal)
      end

      it "does not link to renewals which don't require an initial convictions check" do
        last_modified_renewal = create(:transient_registration, :requires_conviction_check)
        last_modified_renewal.conviction_sign_offs.first.approve!(user)
        link_to_renewal = transient_registration_path(last_modified_renewal.reg_identifier)

        get "/bo/convictions/possible-matches"
        expect(response.body).to_not include(link_to_renewal)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/convictions/possible-matches"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
