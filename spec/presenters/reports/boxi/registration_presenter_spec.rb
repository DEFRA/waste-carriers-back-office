# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe ::Reports::Boxi::RegistrationPresenter do
      let(:registration) { double(:registration) }

      subject { described_class.new(registration, nil) }

      describe "#finance_details_balance" do
        it "returns the balance formatted as pounds and pence" do
          finance_details = double(:finance_details)

          allow(registration).to receive(:finance_details).and_return(finance_details)
          allow(finance_details).to receive(:balance).and_return(0)

          expect(subject.finance_details_balance).to eq("0.00")
        end
      end

      describe "#metadata_date_registered" do
        it "returns a formatted date" do
          metadata = double(:metadata)

          expect(registration).to receive(:metaData).and_return(metadata)
          expect(metadata).to receive(:date_registered).and_return(Date.new(2019, 11, 11))

          expect(subject.metadata_date_registered.to_s).to eq("2019-11-11T00:00Z")
        end
      end

      describe "#metadata_date_activated" do
        it "returns a formatted date" do
          metadata = double(:metadata)

          expect(registration).to receive(:metaData).and_return(metadata)
          expect(metadata).to receive(:date_activated).and_return(Date.new(2019, 11, 11))

          expect(subject.metadata_date_activated.to_s).to eq("2019-11-11T00:00Z")
        end
      end

      describe "#metadata_date_last_modified" do
        it "returns a formatted date" do
          metadata = double(:metadata)

          expect(registration).to receive(:metaData).and_return(metadata)
          expect(metadata).to receive(:last_modified).and_return(Date.new(2019, 11, 11))

          expect(subject.metadata_date_last_modified.to_s).to eq("2019-11-11T00:00Z")
        end
      end

      describe "assistance_mode" do
        let(:metadata) { double(:metadata) }

        before do
          allow(registration).to receive(:metaData).and_return(metadata)
        end

        context "for an unassisted registration" do
          before { allow(metadata).to receive(:route).and_return("DIGITAL") }

          it "returns 'Unassisted'" do
            expect(subject.assistance_mode).to eq("Unassisted")
          end
        end

        context "for a fully assisted registration" do
          before { allow(metadata).to receive(:route).and_return("ASSISTED_DIGITAL") }

          it "returns 'Fully assisted'" do
            expect(subject.assistance_mode).to eq("Fully assisted")
          end
        end

        context "for a partially assisted registration" do
          before { allow(metadata).to receive(:route).and_return("ASSISTED_DIGITAL_FROM_TRANSIENT_REGISTRATION") }

          it "returns 'Partially assisted'" do
            expect(subject.assistance_mode).to eq("Partially assisted")
          end
        end
      end

      describe "#conviction_search_result_searched_at" do
        it "returns a formatted date" do
          conviction_search_result = double(:conviction_search_result)

          expect(registration).to receive(:conviction_search_result).and_return(conviction_search_result)
          expect(conviction_search_result).to receive(:searched_at).and_return(Date.new(2019, 11, 11))

          expect(subject.conviction_search_result_searched_at.to_s).to eq("2019-11-11T00:00Z")
        end
      end

      describe "#expires_on" do
        it "returns a formatted date" do
          expect(registration).to receive(:expires_on).and_return(Date.new(2019, 11, 11))

          expect(subject.expires_on.to_s).to eq("2019-11-11T00:00Z")
        end
      end
    end
  end
end
