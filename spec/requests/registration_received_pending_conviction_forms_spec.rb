# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationReceivedPendingConvictionForms" do
  describe "GET /new" do
    it "returns http success" do
      get "/registration_received_pending_conviction_forms/new"
      expect(response).to have_http_status(:success)
    end
  end

end
