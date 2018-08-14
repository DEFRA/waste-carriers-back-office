# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Root", type: :request do
  describe "GET /" do
    it "renders the dashboards index template" do
      get "/"
      expect(response).to redirect_to(bo_path)
    end

    it "returns a 200 response" do
      get "/"
      expect(response).to have_http_status(302)
    end
  end
end
