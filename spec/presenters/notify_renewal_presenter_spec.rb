# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyRenewalPresenter, type: :helper do
  subject(:presenter) { described_class.new(registration) }

  let(:registration) { create(:registration) }

  describe "#contact_name" do
    it "returns the correct value" do
      expect(presenter.contact_name).to eq("#{registration.first_name} #{registration.last_name}")
    end
  end

  describe "#expiry_date" do
    it "returns the correct value" do
      allow(registration).to receive(:expires_on).and_return(Time.zone.local(2020, 1, 1))
      expect(presenter.expiry_date).to eq("1 January 2020")
    end
  end

  describe "#registration_cost" do
    it "returns the formatted new registration charge" do
      expect(presenter.registration_cost).to eq("184")
    end
  end

  describe "#renewal_cost" do
    it "returns the formatted renewal charge" do
      expect(presenter.renewal_cost).to eq("125")
    end
  end

  describe "#renewal_url" do
    it "returns the correct renewal URL" do
      registration.renew_token = "TOKEN123"
      Rails.configuration.wcrs_fo_link_domain = "https://www.example.com"
      expect(presenter.renewal_url).to eq("www.example.com/fo/renew/TOKEN123")
    end
  end

  describe "#renewal_email_date" do
    let(:first_renewal_email_reminder_days) { 30 }
    let(:expires_on) { Time.zone.now }
    let(:registration) { build(:registration, expires_on: expires_on) }

    it "returns a date object" do
      expected_date = first_renewal_email_reminder_days.days.ago.to_date

      allow(Rails.configuration).to receive(:first_renewal_email_reminder_days).and_return(first_renewal_email_reminder_days)
      expect(presenter.renewal_email_date).to eq(expected_date)
    end
  end
end
