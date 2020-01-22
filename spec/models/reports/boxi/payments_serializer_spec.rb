# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe PaymentsSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        %w[
          RegistrationUID
          OrderKey
          PaymentType
          Amount
          Reference
          Comment
          PaymentReceivedTimestamp
          PaymentEnteredTimestamp
          LastModifiedBy
        ]
      end
      subject { described_class.new(dir) }

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each payment in the registration" do
          payment = double(:payment)
          presenter = double(:presenter)
          finance_details = double(:finance_details)

          values = [
            0,
            "order_key",
            "payment_type",
            "amount",
            "registration_reference",
            "comment",
            "date_received",
            "date_entered",
            "updated_by_user"
          ]

          allow(registration).to receive(:finance_details).and_return(finance_details)
          allow(finance_details).to receive(:payments).and_return([payment])
          expect(PaymentPresenter).to receive(:new).with(payment, nil).and_return(presenter)

          expect(presenter).to receive(:order_key).and_return("order_key")
          expect(presenter).to receive(:payment_type).and_return("payment_type")
          expect(presenter).to receive(:amount).and_return("amount")
          expect(presenter).to receive(:registration_reference).and_return("registration_reference")
          expect(presenter).to receive(:comment).and_return("comment")
          expect(presenter).to receive(:date_received).and_return("date_received")
          expect(presenter).to receive(:date_entered).and_return("date_entered")
          expect(presenter).to receive(:updated_by_user).and_return("updated_by_user")

          expect(CSV).to receive(:open).and_return(csv)
          expect(csv).to receive(:<<).with(headers)
          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end

        context "when there are no finance details available" do
          it "does nothing and returns nil" do
            expect(registration).to receive(:finance_details).and_return(nil)

            expect(subject.add_entries_for(registration, 0)).to be_nil
          end
        end

        context "when there are no payments available" do
          it "does nothing and returns nil" do
            finance_details = double(:finance_details, payments: nil)
            allow(registration).to receive(:finance_details).and_return(finance_details)

            expect(subject.add_entries_for(registration, 0)).to be_nil
          end
        end
      end
    end
  end
end
