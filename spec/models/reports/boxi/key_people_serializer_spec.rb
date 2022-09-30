# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe KeyPeopleSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        %w[
          RegistrationUID
          PersonType
          FirstName
          LastName
          Position
          FlaggedForReview
          ReviewFlagTimestamp
        ]
      end

      subject { described_class.new(dir) }

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each key person in the registration" do
          key_person = double(:key_person)
          presenter = double(:presenter)

          values = [
            0,
            "person_type",
            "first_name",
            "last_name",
            "position",
            "flagged_for_review",
            "review_flag_timestamp"
          ]

          allow(registration).to receive(:key_people).and_return([key_person])
          expect(KeyPersonPresenter).to receive(:new).with(key_person, nil).and_return(presenter)

          expect(presenter).to receive(:person_type).and_return("person_type")
          expect(presenter).to receive(:first_name).and_return("first_name")
          expect(presenter).to receive(:last_name).and_return("last_name")
          expect(presenter).to receive(:position).and_return("position")
          expect(presenter).to receive(:flagged_for_review).and_return("flagged_for_review")
          expect(presenter).to receive(:review_flag_timestamp).and_return("review_flag_timestamp")

          expect(CSV).to receive(:open).and_return(csv)
          expect(csv).to receive(:<<).with(headers)
          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end

        it "sanitize data before inserting them in the csv" do
          key_person = double(:key_person)
          presenter = double(:presenter, position: " string to\r\nsanitize\n").as_null_object

          allow(registration).to receive(:key_people).and_return([key_person])
          allow(KeyPersonPresenter).to receive(:new).with(key_person, nil).and_return(presenter)

          allow(CSV).to receive(:open).and_return(csv)
          allow(csv).to receive(:<<).with(headers)

          expect(csv).to receive(:<<).with(array_including("string to sanitize"))

          subject.add_entries_for(registration, 0)
        end

        context "when there are no key people" do
          it "does nothing and returns nil" do
            allow(registration).to receive(:key_people).and_return(nil)

            expect(subject.add_entries_for(registration, 0)).to be_nil
          end
        end
      end
    end
  end
end
