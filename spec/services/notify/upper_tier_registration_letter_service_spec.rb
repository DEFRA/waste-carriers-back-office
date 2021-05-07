# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe UpperTierRegistrationLetterService do
    let(:template_id) { "92817aa7-6289-4837-a033-96d287644cb3" }
    let(:registration) { create(:registration, :active, expires_on: 1.year.from_now) }

    describe ".run" do
      let(:expected_notify_options) do
        {
          template_id: template_id,
          personalisation: {
            contact_name: "Jane Doe",
            registration_type: "carrier, broker and dealer",
            reg_identifier: registration.reg_identifier,
            company_name: "WasteCo",
            registered_address: "42, Foo Gardens, Baz City, BS1 1AA",
            phone_number: "03708 506506",
            date_registered: registration.metaData.date_registered.in_time_zone("London").to_date.to_s,
            expiry_date: 1.year.from_now.to_formatted_s(:unpadded_day_month_year),
            address_line_1: "Jane Doe",
            address_line_2: "42",
            address_line_3: "Foo Gardens",
            address_line_4: "Baz City",
            address_line_5: "BS1 1AA"
          }
        }
      end

      subject do
        VCR.use_cassette("notify_upper_tier_registration_letter") do
          described_class.run(registration: registration)
        end
      end

      context "in general" do
        before do
          expect_any_instance_of(Notifications::Client)
            .to receive(:send_letter)
            .with(expected_notify_options)
            .and_call_original

          allow_any_instance_of(WasteCarriersEngine::Address)
            .to receive(:postcode)
            .and_return("BS1 1AA")
        end

        it "sends a letter" do
          expect(subject).to be_a(Notifications::Client::ResponseNotification)
          expect(subject.template["id"]).to eq(template_id)
          expect(subject.content["subject"]).to eq(
            "You are now registered as an upper tier waste carrier, broker and dealer"
          )
        end
      end
    end
  end
end
