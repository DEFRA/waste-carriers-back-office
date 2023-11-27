# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CopyCardsOrderCompletedForms" do
  describe "GET /new" do
    it "returns http success" do
      get "/copy_cards_order_completed_forms/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/copy_cards_order_completed_forms/create"
      expect(response).to have_http_status(:success)
    end
  end

end
