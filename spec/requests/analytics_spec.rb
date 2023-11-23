# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Analytics" do
  let(:role) { "agency" }
  let(:user) { create(:user, role: role) }

  before do
    sign_in(user)
    stub_request(:any, /errbit/).to_return(status: 200, body: "", headers: {})
  end

  describe "GET /bo/analytics" do
    let(:start_date) { "2023-01-01" }
    let(:end_date) { "2023-01-31" }

    context "when user has permission to view analytics" do
      let(:role) { "agency_super" }

      before do
        get analytics_path, params: { start_date: start_date, end_date: end_date }
      end

      it "returns HTTP status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end

      it "assigns @analytics_data" do
        expect(assigns(:analytics_data)).not_to be_nil
      end

      it "sets the correct date range" do
        expect(assigns(:start_date)).to eq(Date.parse(start_date))
        expect(assigns(:end_date)).to eq(Date.parse(end_date))
      end
    end

    context "when user does not have permission to view analytics" do
      it "raises an authorization error" do
        get analytics_path
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when dates are not provided" do
      it "sets dates to nil" do
        get analytics_path
        expect(assigns(:start_date)).to be_nil
        expect(assigns(:end_date)).to be_nil
      end
    end
  end
end
