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

  describe "#rejected_header" do
    it "returns a translated message" do
      translated_header = double(:translated_header)
      key = ".registrations.show.status.headings.rejected"

      expect(I18n).to receive(:t).with(key).and_return(translated_header)

      expect(subject.rejected_header).to eq(translated_header)
    end
  end

  describe "#rejected_message" do
    it "returns a translated message" do
      translated_message = double(:translated_message)
      key = ".registrations.show.status.messages.rejected"

      expect(I18n).to receive(:t).with(key).and_return(translated_message)

      expect(subject.rejected_message).to eq(translated_message)
    end
  end

  describe "#finance_details_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_backend_url).and_return("http://example.com")
    end

    it "returns a link to the finance details page in the old system" do
      expect(subject.finance_details_link).to eq("http://example.com/registrations/12345/paymentstatus")
    end
  end

  describe "#edit_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_backend_url).and_return("http://example.com")
    end

    it "returns a link to the edit page in the old system" do
      expect(subject.edit_link).to eq("http://example.com/registrations/12345/edit?edit-process=1")
    end
  end

  describe "#view_confirmation_letter_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_backend_url).and_return("http://example.com")
    end

    it "returns a link to the confirmation letter page in the old system" do
      expect(subject.view_confirmation_letter_link).to eq("http://example.com/registrations/12345/view")
    end
  end

  describe "#order_copy_cards_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_backend_url).and_return("http://example.com")
    end

    it "returns a link to the order copy cards page in the old system" do
      expect(subject.order_copy_cards_link).to eq("http://example.com/your-registration/12345/order/order-copy_cards")
    end
  end

  describe "#revoke_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_backend_url).and_return("http://example.com")
    end

    it "returns a link to the revoke feature in the old system" do
      expect(subject.revoke_link).to eq("http://example.com/registrations/12345/revoke")
    end
  end

  describe "#cease_link" do
    let(:registration) { double(:registration, id: "12345") }

    before do
      expect(Rails.configuration).to receive(:wcrs_backend_url).and_return("http://example.com")
    end

    it "returns a link to the delete feature in the old system" do
      expect(subject.cease_link).to eq("http://example.com/registrations/12345/confirm_delete")
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
