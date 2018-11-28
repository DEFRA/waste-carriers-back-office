# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionsDashboards", type: :request do
  let!(:link_to_possible_matches_renewal) do
    renewal = create(:transient_registration, :requires_conviction_check)
    # Make sure it's one of the 'oldest' renewals so would be top of the list
    renewal.metaData.update_attributes(last_modified: Date.new(1999, 1, 1))

    transient_registration_path(renewal.reg_identifier)
  end

  let!(:link_to_checks_in_progress_renewal) do
    renewal = create(:transient_registration, :has_flagged_conviction_check)
    # Make sure it's one of the 'oldest' renewals so would be top of the list
    renewal.metaData.update_attributes(last_modified: Date.new(1999, 1, 1))

    transient_registration_path(renewal.reg_identifier)
  end

  let!(:link_to_approved_renewal) do
    renewal = create(:transient_registration, :has_approved_conviction_check)
    # Make sure it's one of the 'oldest' renewals so would be top of the list
    renewal.metaData.update_attributes(last_modified: Date.new(1999, 1, 1))

    transient_registration_path(renewal.reg_identifier)
  end

  let!(:link_to_rejected_renewal) do
    renewal = create(:transient_registration, :has_rejected_conviction_check)
    # Make sure it's one of the 'oldest' renewals so would be top of the list
    renewal.metaData.update_attributes(last_modified: Date.new(1999, 1, 1))

    transient_registration_path(renewal.reg_identifier)
  end

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

      it "links to renewals which require an initial convictions check" do
        get "/bo/convictions"
        expect(response.body).to include(link_to_possible_matches_renewal)
      end

      it "does not link to renewals which don't require an initial convictions check" do
        get "/bo/convictions"
        expect(response.body).to_not include(link_to_checks_in_progress_renewal)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/convictions"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/convictions/in-progress" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the possible_matches template" do
        get "/bo/convictions/in-progress"
        expect(response).to render_template(:checks_in_progress)
      end

      it "returns a 200 response" do
        get "/bo/convictions/in-progress"
        expect(response).to have_http_status(200)
      end

      it "links to renewals which have have ongoing conviction checks" do
        get "/bo/convictions/in-progress"
        expect(response.body).to include(link_to_checks_in_progress_renewal)
      end

      it "does not link to renewals which don't have ongoing conviction checks" do
        get "/bo/convictions/in-progress"
        expect(response.body).to_not include(link_to_rejected_renewal)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/convictions/in-progress"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/convictions/approved" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the possible_matches template" do
        get "/bo/convictions/approved"
        expect(response).to render_template(:approved)
      end

      it "returns a 200 response" do
        get "/bo/convictions/approved"
        expect(response).to have_http_status(200)
      end

      it "links to renewals which have have approved conviction checks" do
        get "/bo/convictions/approved"
        expect(response.body).to include(link_to_approved_renewal)
      end

      it "does not link to renewals which don't have approved conviction checks" do
        get "/bo/convictions/approved"
        expect(response.body).to_not include(link_to_possible_matches_renewal)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/convictions/approved"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/convictions/rejected" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the possible_matches template" do
        get "/bo/convictions/rejected"
        expect(response).to render_template(:rejected)
      end

      it "returns a 200 response" do
        get "/bo/convictions/rejected"
        expect(response).to have_http_status(200)
      end

      it "links to renewals which have have rejected conviction checks" do
        get "/bo/convictions/rejected"
        expect(response.body).to include(link_to_rejected_renewal)
      end

      it "does not link to renewals which don't have rejected conviction checks" do
        get "/bo/convictions/rejected"
        expect(response.body).to_not include(link_to_possible_matches_renewal)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/convictions/rejected"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
