# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe CardOrdersExportPresenter do
    subject { described_class.new(order_item_log) }

    # Use different address structures for registered and contact addresses
    # to test handling of blank fields.
    let(:registered_address) do
      {
        house_number: "",
        address_line_1: Faker::Address.street_name,
        address_line_2: Faker::Address.secondary_address,
        address_line_3: nil,
        address_line_4: Faker::Address.community,
        town_city: Faker::Address.city,
        postcode: Faker::Address.postcode,
        country: Faker::Address.country
      }
    end

    let(:contact_address) do
      {
        house_number: "12",
        address_line_1: Faker::Address.street_name,
        address_line_2: Faker::Address.secondary_address,
        address_line_3: Faker::Address.community,
        address_line_4: "",
        town_city: Faker::Address.city,
        postcode: Faker::Address.postcode,
        country: Faker::Address.country
      }
    end

    let(:addresses) do
      [
        registered_address.merge(address_type: "REGISTERED"),
        contact_address.merge(address_type: "POSTAL")
      ]
    end

    let(:business_type) { "limitedCompany" }
    let(:registration) { create(:registration, :has_orders_and_payments, business_type: business_type) }
    let(:order) { registration.finance_details.orders[0] }
    let(:order_item_log) { create(:order_item_log, registration_id: registration.id, order_id: order.id) }

    before { registration.addresses = addresses }

    describe "#reg_identifier" do
      it "returns the registration id" do
        expect(subject.reg_identifier).to eq order_item_log.registration_id
      end
    end

    describe "#date_of_issue" do
      it "returns the date of the registration activation which activated the card order" do
        expect(subject.date_of_issue).to eq order_item_log.activated_at
      end
    end

    describe "#carrier_name" do
      context "when the registration is lower tier" do
        let(:lower_tier) { true }
        let(:upper_tier) { false }

        it "returns the company name" do
          expect(subject.carrier_name).to eq(registration.company_name)
        end
      end

      context "when the registration is upper tier" do
        context "when the registration business type is 'soleTrader'" do
          let(:business_type) { "soleTrader" }

          it "returns the carrier's name" do
            main_person = registration.key_people[0]
            expect(subject.carrier_name).to eq("#{main_person.first_name} #{main_person.last_name}")
          end
        end

        context "when the registration business type is NOT 'sole trader'" do
          it "returns the company name" do
            expect(subject.carrier_name).to eq(registration.company_name)
          end
        end
      end
    end

    describe "base registration details" do
      it "returns the relevant registration attributes" do
        expect(subject.company_name).to eq registration.company_name
        expect(subject.registration_type).to eq registration.registration_type
        expect(subject.registration_date.to_i).to eq registration.metaData.dateRegistered.to_i
        expect(subject.expires_on).to eq registration.expires_on
        expect(subject.contact_phone_number).to eq registration.phone_number
      end
    end

    describe "registered_address fields" do
      it "returns the registered address fields" do
        registered_addr = registration.addresses.select { |a| a.addressType == "REGISTERED" }[0]
        expect(subject.registered_address_line_1).to eq registered_addr.address_line_1
        expect(subject.registered_address_line_2).to eq registered_addr.address_line_2
        expect(subject.registered_address_line_3).to eq registered_addr.address_line_4
        expect(subject.registered_address_line_4).to be_nil
        expect(subject.registered_address_line_5).to be_nil
        expect(subject.registered_address_line_6).to be_nil
        expect(subject.registered_address_town_city).to eq registered_addr.town_city
        expect(subject.registered_address_postcode).to eq registered_addr.postcode
        expect(subject.registered_address_country).to eq registered_addr.country
      end
    end

    describe "#contact_address" do
      it "returns the contact address fields as a hash" do
        contact_addr = registration.addresses.select { |a| a.addressType == "POSTAL" }[0]
        expect(subject.contact_address_line_1).to eq contact_addr.house_number
        expect(subject.contact_address_line_2).to eq contact_addr.address_line_1
        expect(subject.contact_address_line_3).to eq contact_addr.address_line_2
        expect(subject.contact_address_line_4).to eq contact_addr.address_line_3
        expect(subject.contact_address_line_5).to be_nil
        expect(subject.contact_address_line_6).to be_nil
        expect(subject.contact_address_town_city).to eq contact_addr.town_city
        expect(subject.contact_address_postcode).to eq contact_addr.postcode
        expect(subject.contact_address_country).to eq contact_addr.country
      end
    end

  end
end
