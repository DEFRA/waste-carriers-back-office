# frozen_string_literal: true

module Reports
  module Boxi
    class SignOffsSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        confirmed: "Confirmed",
        confirmed_by: "ConfirmedBy",
        confirmed_at: "Timestamp"
      }.freeze

      def add_entries_for(registration, uid)
        (registration.conviction_sign_offs || []).each do |sign_off|
          csv << parse_sign_off(sign_off, uid)
        end
      end

      private

      def parse_sign_off(sign_off, uid)
        presenter = SignOffPresenter.new(sign_off, nil)

        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          else
            presenter.public_send(key)
          end
        end
      end

      def file_name
        "sign_offs.csv"
      end
    end
  end
end
