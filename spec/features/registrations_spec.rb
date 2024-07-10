# frozen_string_literal: true

require "rails_helper"

RSpec.describe "dashboard search" do

  let!(:registration) { create(:registration) }
  let(:reg_identifier) { registration.reg_identifier }

  let(:user) { create(:user) }

  let(:page_dash) { "/bo" }
  let(:page_search) { "/bo?term=1&commit=Search" }
  let(:page_reg_details) { "/bo/registrations/#{reg_identifier}" }
  let(:page_finance_details) { "/bo/resources/#{registration.id}/finance-details" }

  let(:response_html) { Nokogiri::HTML(page.body) }

  let(:back_link) { response_html.at_css('a:contains("Back to search results")')["href"] }

  before { sign_in(user) }

  context "when navigating directly to registration details without a prior search or HTTP referer" do
    before do
      visit page_reg_details
    end

    it { expect(back_link).to eq page_dash }
  end

  context "when navigating from search results to registration details" do
    before do
      visit page_dash
      visit page_search
      visit page_reg_details
    end

    it { expect(back_link).to eq page_search }
  end

  # RUBY-3210
  context "when navigating back to registration details from payment details after a search" do
    before do
      visit page_dash
      visit page_search
      visit page_reg_details
      visit page_finance_details
      visit page_reg_details
    end

    it { expect(back_link).to eq page_search }
  end
end
