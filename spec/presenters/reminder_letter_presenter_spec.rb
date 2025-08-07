# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReminderLetterPresenter do
  include WasteCarriersEngine::ApplicationHelper

  subject { described_class.new(registration, view_context) }

  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }

  describe "#contact_address_lines" do
    let(:company_name) { "company name" }
    let(:contact_address) { build(:address) }
    let(:registration) { double(:registration, company_name: company_name, contact_address: contact_address) }

    it "gets the displayable address lines" do
      expected_address = [
        company_name,
        contact_address.house_number,
        contact_address.address_line_1,
        contact_address.address_line_2,
        contact_address.address_line_3,
        contact_address.address_line_4,
        contact_address.town_city,
        contact_address.postcode,
        contact_address.country
      ].flatten

      expect(subject.contact_address_lines).to eq(expected_address)
    end

    context "when there are no address lines" do
      let(:contact_address) { build(:simple_address, house_number: nil, address_line_1: nil, town_city: nil, postcode: nil) }

      it "throws an error" do
        expect { subject.contact_address_lines }.to raise_error(MissingAddressError)
      end
    end
  end

  describe "#date_of_letter" do
    it "returns a date object for today" do
      expect(subject.date_of_letter).to eq(Time.zone.now.to_fs(:day_month_year))
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
    let(:expires_on) { Time.zone.now }
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
    let(:renewal_cost) { Rails.configuration.renewal_charge }

    it "returns the correct cost" do
      expected_cost = "125"

      allow(Rails.configuration).to receive(:renewal_charge).and_return(renewal_cost)
      expect(subject.renewal_cost).to eq(expected_cost)
    end
  end

  describe "#new_reg_cost" do
    let(:new_reg_cost) { Rails.configuration.new_registration_charge }

    it "returns the correct cost" do
      expected_cost = "184"

      allow(Rails.configuration).to receive(:new_registration_charge).and_return(new_reg_cost)
      expect(subject.new_reg_cost).to eq(expected_cost)
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

  describe "#renewal_url" do
    let(:token) { "tokengoeshere" }
    let(:registration) { double(:registration, renew_token: token) }

    it "returns a correctly formatted URL" do
      expected_url = "wastecarriersregistration.service.gov.uk/fo/renew/tokengoeshere"

      allow(Rails.configuration).to receive(:wcrs_fo_link_domain).and_return("https://wastecarriersregistration.service.gov.uk")
      expect(subject.renewal_url).to eq(expected_url)
    end
  end

  describe "#from_email" do
    let(:email_service_email) { "email_service_email@wcr.gov.uk" }

    it "returns the email_service_email from the config" do
      allow(Rails.configuration).to receive(:email_service_email).and_return(email_service_email)
      expect(subject.from_email).to eq(email_service_email)
    end
  end
end
