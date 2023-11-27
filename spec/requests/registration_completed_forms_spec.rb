# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationCompletedForms" do
  describe "GET /new" do
    it "returns http success" do
      get "/registration_completed_forms/new"
      expect(response).to have_http_status(:success)
    end
  end

end
