# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe SignOffsSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        %w[
          RegistrationUID
          Confirmed
          ConfirmedBy
          Timestamp
        ]
      end

      subject { described_class.new(dir) }

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each conviction_sign_off in the registration" do
          sign_off = double(:sign_off)
          presenter = double(:presenter)

          values = [
            0,
            "confirmed",
            "confirmed_by",
            "confirmed_at"
          ]

          allow(registration).to receive(:conviction_sign_offs).and_return([sign_off])
          expect(SignOffPresenter).to receive(:new).with(sign_off, nil).and_return(presenter)

          expect(presenter).to receive(:confirmed).and_return("confirmed")
          expect(presenter).to receive(:confirmed_by).and_return("confirmed_by")
          expect(presenter).to receive(:confirmed_at).and_return("confirmed_at")

          expect(CSV).to receive(:open).and_return(csv)
          expect(csv).to receive(:<<).with(headers)
          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end

        context "when there are no sign offs data available" do
          it "does nothing and returns nil" do
            allow(registration).to receive(:conviction_sign_offs).and_return(nil)

            expect(subject.add_entries_for(registration, 0)).to be_nil
          end
        end
      end
    end
  end
end
