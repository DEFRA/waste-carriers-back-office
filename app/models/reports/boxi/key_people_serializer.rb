# frozen_string_literal: true

module Reports
  module Boxi
    class KeyPeopleSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        person_type: "PersonType",
        first_name: "FirstName",
        last_name: "LastName",
        position: "Position",
        flagged_for_review: "FlaggedForReview",
        review_flag_timestamp: "ReviewFlagTimestamp"
      }.freeze

      def add_entries_for(registration, uid)
        return if registration.key_people.blank?

        registration.key_people.each do |key_person|
          csv << parse_key_person(key_person, uid)
        end
      end

      private

      def parse_key_person(key_person, uid)
        presenter = KeyPersonPresenter.new(key_person, nil)

        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          else
            sanitize(presenter.public_send(key))
          end
        end
      end

      def file_name
        "key_people.csv"
      end
    end
  end
end
