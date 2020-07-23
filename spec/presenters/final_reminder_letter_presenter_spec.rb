# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinalReminderLetterPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#display_covid_warning?" do
    context "when the feature toggle is active" do
      before { expect(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:display_covid_warning_in_letters).and_return(true) }

      it "is true" do
        expect(subject.display_covid_warning?).to eq(true)
      end
    end

    context "when the feature toggle is not active" do
      before { expect(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:display_covid_warning_in_letters).and_return(false) }

      it "is false" do
        expect(subject.display_covid_warning?).to eq(false)
      end
    end
  end

  describe "#contact_address_lines" do
    let(:company_name) { "company name" }
    let(:contact_address) { double(:address) }
    let(:registration) { double(:registration, company_name: company_name, contact_address: contact_address) }
    let(:address_lines) { ["line 1", "line 2"] }

    before { expect_any_instance_of(WasteCarriersEngine::ApplicationHelper).to receive(:displayable_address).and_return(address_lines) }

    it "gets the displayable address lines" do
      expected_address = [company_name, address_lines].flatten
      expect(subject.contact_address_lines).to eq(expected_address)
    end

    context "when there there are no address lines" do
      let(:address_lines) { [] }

      it "throws an error" do
        expect { subject.contact_address_lines }.to raise_error(MissingAddressError)
      end
    end
  end

  describe "#date_of_letter" do
    it "returns a date object for today" do
      expect(subject.date_of_letter).to eq(Time.now.to_date.to_formatted_s(:day_month_year))
    end
  end

  describe "#contact_full_name" do
    let(:first_name) { "Firstname" }
    let(:last_name) { "Firstname" }
    let(:registration) { double(:registration, first_name: first_name, last_name: last_name) }

    it "returns a correctly formatted name" do
      expect(subject.contact_full_name).to eq("#{first_name} #{last_name}")
    end
  end

  describe "#expiry_date" do
    let(:expires_on) { Time.now }
    let(:registration) { double(:registration, expires_on: expires_on) }

    it "returns a date object" do
      expect(subject.expiry_date).to be_a(Date)
    end

    context "when there is no expires_on" do
      let(:expires_on) { nil }

      it "returns nil" do
        expect(subject.expiry_date).to be_nil
      end
    end
  end

  describe "#renewal_cost" do
    let(:renewal_cost) { 10500 }

    it "returns the correct cost" do
      expected_cost = "105"

      expect(Rails.configuration).to receive(:renewal_charge).and_return(renewal_cost)
      expect_any_instance_of(WasteCarriersEngine::ApplicationHelper).to receive(:display_pence_as_pounds).with(renewal_cost).and_return(expected_cost)
      expect(subject.renewal_cost).to eq(expected_cost)
    end
  end

  describe "#new_reg_cost" do
    let(:new_reg_cost) { 15400 }

    it "returns the correct cost" do
      expected_cost = "154"

      expect(Rails.configuration).to receive(:new_registration_charge).and_return(new_reg_cost)
      expect_any_instance_of(WasteCarriersEngine::ApplicationHelper).to receive(:display_pence_as_pounds).with(new_reg_cost).and_return(expected_cost)
      expect(subject.new_reg_cost).to eq(expected_cost)
    end
  end

  describe "#renewal_email_date" do
    let(:first_renewal_email_reminder_days) { 30 }
    let(:expires_on) { Time.now }
    let(:registration) { double(:registration, expires_on: expires_on) }

    it "returns a date object" do
      expected_date = first_renewal_email_reminder_days.days.ago.to_date

      expect(Rails.configuration).to receive(:first_renewal_email_reminder_days).and_return(first_renewal_email_reminder_days)
      expect(subject.renewal_email_date).to eq(expected_date)
    end
  end

  describe "#renewal_url" do
    let(:token) { "tokengoeshere" }
    let(:registration) { double(:registration, renew_token: token) }

    it "returns a correctly formatted URL" do
      expected_url = "wastecarriersregistration.service.gov.uk/fo/renew/tokengoeshere"

      expect(Rails.configuration).to receive(:wcrs_renewals_url).and_return("https://wastecarriersregistration.service.gov.uk")
      expect(subject.renewal_url).to eq(expected_url)
    end
  end
end
