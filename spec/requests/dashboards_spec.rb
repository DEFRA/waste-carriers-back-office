# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "/bo" do
    it "renders the index template" do
      get "/bo"
      expect(response).to render_template(:index)
    end

    it "returns a 200 response" do
      get "/bo"
      expect(response).to have_http_status(200)
    end
  end
end
