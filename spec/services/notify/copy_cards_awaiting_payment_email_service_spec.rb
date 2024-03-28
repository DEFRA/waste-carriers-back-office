# frozen_string_literal: true

require "rails_helper"

module Notify

  RSpec.describe CopyCardsAwaitingPaymentEmailService do
    describe ".run" do
      let(:template_id) { "56997dd9-852f-4e18-b4e2-c008a9398bfe" }
      let(:registration) { create(:registration, :has_copy_cards_order) }
      let(:order) { registration.finance_details.orders.last }

      let(:expected_notify_options) do
        {
          email_address: "whatever@example.com",
          template_id: template_id,
          personalisation: {
            reg_identifier: registration.reg_identifier,
            first_name: "Jane",
            last_name: "Doe",
            total_cards: 1,
            ordered_on: order.date_created.to_datetime.to_fs(:day_month_year),
            payment_due: "5",
            sort_code: "60-70-80",
            account_number: "1001 4411"
          }
        }
      end
      let(:notifications_client) { Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key) }

      context "with a contact_email" do
        before do
          allow(notifications_client)
            .to receive(:send_email)
            .with(expected_notify_options)
            .and_call_original
        end

        subject(:run_service) do
          VCR.use_cassette("notify_copy_cards_awaiting_payment_sends_an_email") do
            described_class.run(registration: registration, order: order)
          end
        end

        it "sends an email" do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
          expect(run_service.template["id"]).to eq(template_id)
          expect(run_service.content["subject"])
            .to eq("You need to pay for your waste carriers registration card order")
        end
      end

      context "with no contact_email" do
        before { registration.contact_email = nil }

        it "does not attempt to send an email" do
          expect(notifications_client).not_to receive(:send_email)

          described_class.run(registration: registration, order: order)
        end
      end
    end
  end
end
