# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyRenewalLetterPresenter do
  subject { described_class.new(registration) }

  let(:registration) { create(:registration) }

  describe "#contact_name" do
    it "returns the correct value" do
      expect(subject.contact_name).to eq("#{registration.first_name} #{registration.last_name}")
    end
  end

  describe "#expiry_date" do
    it "returns the correct value" do
      allow(registration).to receive(:expires_on).and_return(Time.zone.local(2020, 1, 1))
      expect(subject.expiry_date).to eq("1 January 2020")
    end
  end

  describe "#registration_cost" do
    let(:cost) { 15_400 }

    it "returns the correct cost" do
      expected_cost = "£154"

      allow(Rails.configuration).to receive(:new_registration_charge).and_return(cost)
      allow_any_instance_of(WasteCarriersEngine::ApplicationHelper).to receive(:display_pence_as_pounds).with(cost).and_return(expected_cost)
      expect(subject.registration_cost).to eq(expected_cost)
    end
  end

  describe "#renewal_cost" do
    let(:cost) { 10_500 }

    it "returns the correct cost" do
      expected_cost = "£105"

      allow(Rails.configuration).to receive(:renewal_charge).and_return(cost)
      allow_any_instance_of(WasteCarriersEngine::ApplicationHelper).to receive(:display_pence_as_pounds).with(cost).and_return(expected_cost)
      expect(subject.renewal_cost).to eq(expected_cost)
    end
  end

  describe "#renewal_url" do
    let(:token) { "tokengoeshere" }
    let(:registration) { double(:registration, renew_token: token) }

    it "returns a correctly formatted URL" do
      expected_url = "wastecarriersregistration.service.gov.uk/fo/renew/tokengoeshere"

      allow(Rails.configuration).to receive(:wcrs_fo_link_domain).and_return("https://wastecarriersregistration.service.gov.uk")
      expect(subject.renewal_url).to eq(expected_url)
    end
  end

  describe "#renewal_email_date" do
    let(:first_renewal_email_reminder_days) { 30 }
    let(:expires_on) { Time.zone.now }
    let(:registration) { double(:registration, expires_on: expires_on) }

    it "returns a date object" do
      expected_date = first_renewal_email_reminder_days.days.ago.to_date

      allow(Rails.configuration).to receive(:first_renewal_email_reminder_days).and_return(first_renewal_email_reminder_days)
      expect(subject.renewal_email_date).to eq(expected_date)
    end
  end
end
