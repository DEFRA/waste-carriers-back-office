# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DefraQuarterlyStats" do

  describe "GET /bo/quarterly_reports" do

    context "when a cbd_user is signed in" do
      let(:user) { create(:user, role: :cbd_user) }

      before do
        sign_in(user)
      end

      it "returns HTTP status 200" do
        get quarterly_reports_path

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
