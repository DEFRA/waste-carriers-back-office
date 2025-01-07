# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BaseSerializer do

    describe "#to_csv" do

      context "when the serializer is for registrations" do
        let(:test_class) do
          Class.new(described_class) do

            const_set(:ATTRIBUTES, { tier: "tier" })

            def scope
              ::WasteCarriersEngine::Registration.all # Will not actually be called, just stubbed
            end

            def parse_object(registration)
              [registration.tier]
            end
          end
        end
        let(:registration) { build(:registration) }

        subject { test_class.new }

        before do
          allow(WasteCarriersEngine::Registration).to receive(:all).and_return([registration])
          allow(Rails.logger).to receive(:error)
          allow(Airbrake).to receive(:notify)
        end

        context "with a valid object" do
          before { allow(registration).to receive(:tier).and_return("UPPER") }

          it "returns a csv version of the given data based on attributes" do
            expect(subject.to_csv).to eq("\"tier\"\n\"UPPER\"\n")
          end
        end

        context "with an invalid object" do
          before { allow(registration).to receive(:tier).and_raise(StandardError) }

          it "logs an error including the registration's reg_identifier" do
            subject.to_csv
            expect(Rails.logger).to have_received(:error).with(/.*#{registration.reg_identifier}.*/)
          end
        end
      end

      context "when the serializer is for non-registration objects" do
        let(:test_class) do
          Class.new(described_class) do

            const_set(:ATTRIBUTES, { postcode: "postcode" })

            def scope
              ::WasteCarriersEngine::Address.all # Will not actually be called, just stubbed
            end

            def parse_object(address)
              [address.postcode]
            end
          end
        end
        let(:address) { build(:address) }

        subject { test_class.new }

        before do
          allow(WasteCarriersEngine::Address).to receive(:all).and_return([address])
          allow(Rails.logger).to receive(:error)
          allow(Airbrake).to receive(:notify)
        end

        context "with a valid object" do
          before { allow(address).to receive(:postcode).and_return("BS1 5AH") }

          it "returns a csv version of the given data based on attributes" do
            expect(subject.to_csv).to eq("\"postcode\"\n\"BS1 5AH\"\n")
          end
        end

        context "with an invalid object" do
          before { allow(address).to receive(:postcode).and_raise(StandardError) }

          it "logs an error" do
            subject.to_csv
            expect(Rails.logger).to have_received(:error)
          end
        end
      end
    end
  end
end
