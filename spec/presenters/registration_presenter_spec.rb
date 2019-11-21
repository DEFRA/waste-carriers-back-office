# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#display_expiry_date" do
    let(:expires_on) { Time.now }
    let(:registration) { double(:registration, expires_on: expires_on) }

    it "returns a date object" do
      expect(subject.display_expiry_date).to be_a(Date)
    end

    context "when there is no expire date" do
      let(:expires_on) { nil }

      it "returns nil" do
        expect(subject.display_expiry_date).to be_nil
      end
    end
  end

  describe "#finance_details_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_frontend_url).and_return("http://example.com")
    end

    it "returns a link to the finance details page in the old system" do
      expect(subject.finance_details_link).to eq("http://example.com/registrations/12345/paymentstatus")
    end
  end

  describe "#display_registration_status" do
    let(:metadata) { double(:metadata, status: "PENDING") }
    let(:registration) { double(:registration, metaData: metadata) }

    it "returns a titleized status" do
      expect(subject.display_registration_status).to eq("Pending")
    end
  end
end
