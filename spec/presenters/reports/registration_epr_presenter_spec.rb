# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe RegistrationEprPresenter do
    subject { described_class.new(registration, nil) }
    let(:registration) { double(:registration) }

    describe "#reg_identifier" do
      it "returns the object reg identifier" do
        result = double(:result)

        expect(registration).to receive(:reg_identifier).and_return(result)
        expect(subject.reg_identifier).to eq(result)
      end
    end

    describe "#metadata_date_activated" do
      it "returns the object address uprn" do
        metadata = double(:metadata)

        expect(registration).to receive(:metaData).and_return(metadata)
        expect(metadata).to receive(:date_activated).and_return(Time.new(2015, 1, 1))

        expect(subject.metadata_date_activated).to eq("2015-01-01")
      end
    end

    describe "#company_name" do
      it "returns the object company_name" do
        result = double(:result)

        expect(registration).to receive(:company_name).and_return(result)

        expect(subject.company_name).to eq(result)
      end
    end

    describe "#expires_on" do
      before do
        expect(registration).to receive(:lower_tier?).and_return(lower_tier)
      end

      context "when the registration is a lower_tier" do
        let(:lower_tier) { true }

        it "returns nil" do
          expect(subject.expires_on).to be_nil
        end
      end

      context "when the registration is not a lower tier" do
        let(:lower_tier) { false }

        context "when the registration had a COVID extension" do
          before do
            expect(Rails.configuration).to receive(:end_of_covid_extension).and_return(Date.new(2020, 10, 1))
          end

          it "returns the object expires_on formatted plus grace window days" do
            allow(Rails.configuration).to receive(:grace_window).and_return(3)

            allow(registration).to receive(:expires_on).and_return(Time.new(2015, 1, 1))

            expect(subject.expires_on).to eq("2015-01-04")
          end
        end

        context "when the registration did not have a COVID extension" do
          before do
            expect(Rails.configuration).to receive(:end_of_covid_extension).and_return(Date.new(2010, 1, 1))
          end

          it "returns the object expires_on formatted" do
            allow(registration).to receive(:expires_on).and_return(Time.new(2015, 1, 1))

            expect(subject.expires_on).to eq("2015-01-01")
          end
        end
      end
    end

    describe "#company_no" do
      before do
        expect(registration).to receive(:business_type).and_return(business_type)
      end

      context "when the registration business type is not limitedCompany" do
        let(:business_type) { "foo" }

        it "returns nil" do
          expect(subject.company_no).to eq(nil)
        end
      end

      context "when the registration business type is limitedCompany" do
        let(:business_type) { "limitedCompany" }

        context "when the company number is nil" do
          it "returns nil" do
            expect(registration).to receive(:company_no).and_return(nil)

            expect(subject.company_no).to be_nil
          end
        end

        context "when the company number as whitespaces" do
          it "returns a formatted number" do
            expect(registration).to receive(:company_no).and_return(" 1234 ")

            expect(subject.company_no).to eq("1234")
          end
        end

        context "when the company number only contains 0s" do
          it "returns nil" do
            expect(registration).to receive(:company_no).and_return(" 0000000 ")

            expect(subject.company_no).to be_nil
          end
        end
      end
    end

    describe "#business_type" do
      it "returns the object business_type" do
        result = double(:result)

        expect(registration).to receive(:business_type).and_return(result)

        expect(subject.business_type).to eq(result)
      end
    end

    describe "#tier" do
      it "returns the object tier" do
        result = double(:result)

        expect(registration).to receive(:tier).and_return(result)

        expect(subject.tier).to eq(result)
      end
    end

    describe "#registration_type" do
      before do
        expect(registration).to receive(:lower_tier?).and_return(lower_tier)
      end

      context "when the registration is a lower tier" do
        let(:lower_tier) { true }

        it "returns carrier_broker_dealer" do
          expect(subject.registration_type).to eq("carrier_broker_dealer")
        end
      end

      context "when the registration is not a lower tier" do
        let(:lower_tier) { false }

        it "returns the object registration_type" do
          result = double(:result)

          expect(registration).to receive(:registration_type).and_return(result)

          expect(subject.registration_type).to eq(result)
        end
      end
    end

    describe "#company_address_uprn" do
      it "returns the object address uprn" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:uprn).and_return(result)

        expect(subject.company_address_uprn).to eq(result)
      end
    end

    describe "#company_address_house_number" do
      it "returns the object address house_number" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:house_number).and_return(result)

        expect(subject.company_address_house_number).to eq(result)
      end
    end

    describe "#company_address_address_line_1" do
      it "returns the object address address_line_1" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:address_line_1).and_return(result)

        expect(subject.company_address_address_line_1).to eq(result)
      end
    end

    describe "#company_address_address_line_2" do
      it "returns the object address address_line_2" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:address_line_2).and_return(result)

        expect(subject.company_address_address_line_2).to eq(result)
      end
    end

    describe "#company_address_address_line_3" do
      it "returns the object address address_line_3" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:address_line_3).and_return(result)

        expect(subject.company_address_address_line_3).to eq(result)
      end
    end

    describe "#company_address_address_line_4" do
      it "returns the object address address_line_4" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:address_line_4).and_return(result)

        expect(subject.company_address_address_line_4).to eq(result)
      end
    end

    describe "#company_address_town_city" do
      it "returns the object address town_city" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:town_city).and_return(result)

        expect(subject.company_address_town_city).to eq(result)
      end
    end

    describe "#company_address_postcode" do
      it "returns the object address postcode" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:postcode).and_return(result)

        expect(subject.company_address_postcode).to eq(result)
      end
    end

    describe "#company_address_country" do
      it "returns the object address country" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:country).and_return(result)

        expect(subject.company_address_country).to eq(result)
      end
    end

    describe "#company_address_easting" do
      it "returns the object address easting" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:easting).and_return(result)

        expect(subject.company_address_easting).to eq(result)
      end
    end

    describe "#company_address_northing" do
      it "returns the object address northing" do
        company_address = double(:company_address)
        result = double(:result)

        expect(registration).to receive(:company_address).and_return(company_address)
        expect(company_address).to receive(:northing).and_return(result)

        expect(subject.company_address_northing).to eq(result)
      end
    end
  end
end
