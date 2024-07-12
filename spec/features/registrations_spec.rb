# frozen_string_literal: true

require "rails_helper"

RSpec.describe "registration dashboard search" do

  let!(:registration) { create(:registration) }
  let(:reg_identifier) { registration.reg_identifier }

  let(:user) { create(:user) }

  let(:page_dash) { "/bo" }
  let(:page_search) { "/bo?term=1&commit=Search" }
  let(:page_reg_details) { "/bo/registrations/#{reg_identifier}" }
  let(:page_finance_details) { "/bo/resources/#{registration.id}/finance-details" }

  let(:response_html) { Nokogiri::HTML(page.body) }

  # allow for multiple links in the page with different link text
  let(:back_link_texts) { response_html.css("a[href=\"#{expected_link_target}\"]").map(&:text) }
  let(:back_link_target) { response_html.at_css("a:contains(\"#{expected_link_text}\")")["href"] }

  before do
    sign_in(user)

    visited_pages.each { |page| visit page }
  end

  shared_examples "expected link and text" do
    it { expect(back_link_texts).to include expected_link_text }
    it { expect(back_link_target).to eq expected_link_target }
  end

  shared_examples "back to dashboard link" do
    let(:expected_link_target) { page_dash }
    let(:expected_link_text) { "Dashboard" }

    it_behaves_like "expected link and text"
  end

  shared_examples "back to search results link" do
    let(:expected_link_target) { page_search }
    let(:expected_link_text) { "Back to search results" }

    it_behaves_like "expected link and text"
  end

  context "when navigating directly to registration details without a prior search or HTTP referer" do
    let(:visited_pages) { [page_reg_details] }

    it_behaves_like "back to dashboard link"
  end

  context "when navigating directly to payment details and then back to registration details" do
    let(:visited_pages) { [page_finance_details, page_reg_details] }

    it_behaves_like "back to dashboard link"
  end

  context "when navigating from search results to registration details" do
    let(:visited_pages) { [page_dash, page_search, page_reg_details] }

    it_behaves_like "back to search results link"
  end

  # Use request spec "get" instead of Capybara visit so can set HTTP_REFERER
  context "when navigating to registration details without a prior search and with a HTTP_REFERER" do
    let(:visited_pages) { [] }
    let(:http_referer) { Faker::Internet.url }
    let(:expected_link_target) { http_referer }
    let(:expected_link_text) { "Back" }
    let(:session) { ActionDispatch::Integration::Session.new(Rails.application) }
    let(:response_html) { Nokogiri::HTML(session.response.body) }

    before { session.get(page_reg_details, headers: { HTTP_REFERER: http_referer }) }

    it_behaves_like "expected link and text"
  end

  # RUBY-3210
  context "when navigating back to registration details from payment details after a search" do
    let(:visited_pages) { [page_dash, page_search, page_reg_details, page_finance_details, page_reg_details] }

    it_behaves_like "back to search results link"
  end
end
