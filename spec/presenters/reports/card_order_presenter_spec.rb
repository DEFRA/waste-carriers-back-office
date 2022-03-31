# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe CardOrderPresenter do
    subject { described_class.new(order_item_log) }

    export_date_format = "%d/%m/%Y"

    let(:business_type) { "limitedCompany" }
    let(:company_name) { Faker::Company.name }
    let(:registered_company_name) { nil }
    let(:registration) do
      create(:registration,
             :has_orders_and_payments,
             business_type: business_type,
             company_name: company_name,
             registered_company_name: registered_company_name,
             expires_on: DateTime.now.next_year(3))
    end
    let(:order) { registration.finance_details.orders[0] }
    let(:order_item_log) { create(:order_item_log, registration_id: registration.id, order_id: order.id) }

    describe "#reg_identifier" do
      it "returns the registration identifier" do
        expect(subject.reg_identifier).to eq registration.reg_identifier
      end
    end

    describe "#date_of_issue" do
      it "returns the date of the registration activation which activated the card order" do
        expect(subject.date_of_issue).to eq order_item_log.activated_at.strftime(export_date_format)
      end
    end

    describe "#carrier_name" do
      context "when the registration business type is 'soleTrader'" do
        let(:business_type) { "soleTrader" }

        it "returns the carrier's name" do
          main_person = registration.key_people[0]
          expect(subject.carrier_name).to eq("#{main_person.first_name} #{main_person.last_name}")
        end
      end

      context "when the registration business type is NOT 'sole trader'" do
        context "when the registration has a registered_company_name" do
          before { registration.update(registered_company_name: "Acme Ltd") }

          it "returns the registered_company_name" do
            expect(subject.carrier_name).to eq("Acme Ltd")
          end
        end

        context "when the registration does not have a registered_company_name" do
          it "returns the company name" do
            expect(subject.carrier_name).to eq(registration.company_name)
          end
        end
      end
    end

    describe "#company_name" do
      context "when they registration does not have a company_name" do
        let(:company_name) { nil }

        it "is blank" do
          expect(subject.company_name).to be_blank
        end
      end
    end

    describe "base registration details" do
      it "returns the relevant registration attributes" do
        expect(subject.company_name).to eq registration.company_name
        expect(subject.registration_type).to eq registration.registration_type
        expect(subject.registration_date).to eq registration.metaData.dateRegistered.strftime(export_date_format)
        expect(subject.expires_on).to eq registration.expires_on.strftime(export_date_format)
        expect(subject.contact_phone_number).to eq "=\"#{registration.phone_number}\""
      end
    end

    RSpec.shared_examples "address fields" do |prefix, address_type|
      # Allow these to be overridden to test company name on house number and address line 1
      let(:house_number) { Faker::Number.number(digits: 2) }
      let(:address_line_1) { Faker::Address.street_name }

      let(:registered_address) do
        build(:address, :registered, house_number: house_number, address_line_1: address_line_1)
      end
      let(:contact_address) do
        build(:address, :contact, house_number: house_number, address_line_1: address_line_1)
      end

      before do
        registration.addresses = [registered_address, contact_address]
      end

      let(:registration_address) { registration.addresses.select { |a| a.addressType == address_type }[0] }

      context "with all address lines populated" do
        it "returns the address fields" do
          expect(subject.send("#{prefix}_address_line_1")).to eq registration_address.house_number
          expect(subject.send("#{prefix}_address_line_2")).to eq registration_address.address_line_1
          expect(subject.send("#{prefix}_address_line_3")).to eq registration_address.address_line_2
          expect(subject.send("#{prefix}_address_line_4")).to eq registration_address.address_line_3
          expect(subject.send("#{prefix}_address_line_5")).to eq registration_address.address_line_4
          expect(subject.send("#{prefix}_address_town_city")).to eq registration_address.town_city
          expect(subject.send("#{prefix}_address_postcode")).to eq registration_address.postcode
          expect(subject.send("#{prefix}_address_country")).to eq registration_address.country
        end
      end

      context "with all address lines nil" do
        address_attributes = %i[house_number address_line_1 address_line_2 address_line_3
                                address_line_4 town_city postcode country]
        presenter_address_methods = %i[address_line_1 address_line_2 address_line_3 address_line_4
                                       address_line_5 address_town_city address_postcode address_country]
        before do
          registration_address.assign_attributes(address_attributes.map { |a| [a, nil] }.to_h)
        end

        it "the presenter methods do not raise an exception" do
          presenter_address_methods.each do |a|
            expect { subject.send("#{prefix}_#{a}") }.not_to raise_exception
          end
        end
      end

      context "with a nil company_name" do
        before { registration.company_name = nil }

        it "does not raise an exception" do
          expect { subject.send("#{prefix}_address_line_1") }.not_to raise_exception
        end
      end

      context "checking for company name in the address fields" do

        shared_examples "de-duplicates address fields" do |registration_attribute|
          context "with the source value in address line 1" do
            let(:house_number) { nil }
            context "and the source value is a case sensitive match" do
              let(:address_line_1) { registration.public_send(registration_attribute) }

              it "does not present the source value in the subject's address line 1" do
                expect(subject.send("#{prefix}_address_line_1")).not_to eq registration_address.address_line_1
                expect(subject.send("#{prefix}_address_line_1")).to eq registration_address.address_line_2
              end
            end

            context "and the source value is in a different case" do
              let(:address_line_1) { registration.public_send(registration_attribute).upcase }

              it "still does not present the source value in the subject's address line 1" do
                expect(subject.send("#{prefix}_address_line_1")).not_to eq registration_address.address_line_1
              end
            end
          end

          context "with the source value in house number" do
            context "and the source value is a case sensitive match" do
              let(:house_number) { registration.public_send(registration_attribute) }

              it "does not present the source value in the subject's address line 1" do
                expect(subject.send("#{prefix}_address_line_1")).not_to eq registration_address.house_number
              end
            end

            context "and the source value is in a different case" do
              let(:house_number) { registration.public_send(registration_attribute).upcase }

              it "still does not present the source value in the subject's address line 1" do
                expect(subject.send("#{prefix}_address_line_1")).not_to eq registration_address.house_number
              end
            end
          end
        end

        context "for company_name" do
          it_behaves_like "de-duplicates address fields", :company_name
        end

        context "for registered_company_name" do
          let(:registered_company_name) { Faker::Company.name }
          it_behaves_like "de-duplicates address fields", :registered_company_name
        end

      end
    end

    describe "address fields" do
      context "for the registered address" do
        it_behaves_like "address fields", "registered", "REGISTERED"
      end

      context "for the contact address" do
        it_behaves_like "address fields", "contact", "POSTAL"
      end
    end
  end
end
