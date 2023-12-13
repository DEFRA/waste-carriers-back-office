# frozen_string_literal: true

require "rails_helper"

module Notify

  # TODO: Refactor to remove the use of allow_any_instance_of
  # rubocop:disable RSpec/AnyInstance
  RSpec.describe CopyCardsOrderCompletedEmailService do
    describe ".run" do
      let(:template_id) { "543a89cd-056e-4e9b-a55b-6416980f5472" }
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
            total_paid: "5"
          }
        }
      end

      context "with a contact_email" do
        before do
          allow_any_instance_of(Notifications::Client)
            .to receive(:send_email)
            .with(expected_notify_options)
            .and_call_original
        end

        subject(:run_service) do
          VCR.use_cassette("notify_copy_cards_order_completed_sends_an_email") do
            described_class.run(registration: registration, order: order)
          end
        end

        it "sends an email" do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
          expect(run_service.template["id"]).to eq(template_id)
          expect(run_service.content["subject"]).to eq("We’re printing your waste carriers registration cards")
        end
      end

      context "with no contact_email" do
        before { registration.contact_email = nil }

        it "does not attempt to send an email" do
          expect_any_instance_of(Notifications::Client).not_to receive(:send_email)

          described_class.run(registration: registration, order: order)
        end
      end
    end
  end
  # rubocop:enable RSpec/AnyInstance
end
