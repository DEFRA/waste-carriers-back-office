# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderCopyCardsCompletionService do
  describe ".run" do

    let(:contact_email) { Faker::Internet.email }
    let(:transient_registration) { create(:order_copy_cards_registration, :has_finance_details, contact_email: contact_email) }
    let(:registration) { transient_registration.registration }
    let(:transient_finance_details) { transient_registration.finance_details }

    # Ensure registration activation date is prior to the card order date
    before do
      allow(registration).to receive(:save!)
      allow(registration.finance_details).to receive(:update_balance)
      allow(transient_registration).to receive(:delete)

      registration.metaData.dateActivated = 1.month.ago
    end

    RSpec.shared_examples "completes the order" do |notify_email_service|
      before do
        allow(notify_email_service).to receive(:run)
      end

      it "merges finance details" do
        described_class.run(transient_registration)

        expect(registration.finance_details).to have_received(:update_balance)
      end

      it "merges the order" do
        first_order = transient_finance_details.orders[0]
        described_class.run(transient_registration)

        expect(registration.finance_details.orders).to include(first_order)
      end

      it "deletes the transient registration" do
        described_class.run(transient_registration)

        expect(transient_registration).to have_received(:delete)
      end

      it "saves the registration" do
        described_class.run(transient_registration)

        expect(registration).to have_received(:save!)
      end

      context "with a non-assisted-digital email address" do
        let(:contact_email) { Faker::Internet.email }

        it "sends an email using the appropriate service" do
          described_class.run(transient_registration)

          order = transient_finance_details.reload.orders[0]
          expect(order.class).to eq(WasteCarriersEngine::Order)

          expect(notify_email_service)
            .to have_received(:run)
            .with(registration: registration, order: transient_finance_details.orders[0])
        end
      end

      context "when the registration has a nil contact email" do
        let(:contact_email) { nil }

        it "does not send an email" do
          described_class.run(transient_registration)

          expect(notify_email_service).not_to have_received(:run)
        end
      end
    end

    context "when the registration has not been paid in full" do
      before do
        allow(transient_registration).to receive(:unpaid_balance?).and_return(true)
      end

      it_behaves_like "completes the order", Notify::CopyCardsAwaitingPaymentEmailService

      it "does not merge the payment" do
        described_class.run(transient_registration)
        expect(registration.finance_details.payments).not_to include(transient_finance_details.payments[0])
      end

      it "does not create an order item log" do
        expect { described_class.run(transient_registration) }.not_to change(WasteCarriersEngine::OrderItemLog, :count).from(0)
      end
    end

    context "when the registration has been paid in full" do
      before do
        transient_finance_details.payments << build(:payment, :bank_transfer, amount: 500)
        transient_finance_details.update_balance
        transient_finance_details.save
      end

      it_behaves_like "completes the order", Notify::CopyCardsOrderCompletedEmailService

      it "merges the payment" do
        first_payment = transient_finance_details.payments[0]
        expect(first_payment.class).to eq(WasteCarriersEngine::Payment)
        described_class.run(transient_registration)
        expect(registration.finance_details.payments).to include(first_payment)
      end

      it "creates one or more order item logs" do
        expect { described_class.run(transient_registration) }.to change(WasteCarriersEngine::OrderItemLog, :count).from(0)
      end

      it "creates order item logs with activated_at set to the current time" do
        described_class.run(transient_registration)
        first_card_order_item = WasteCarriersEngine::OrderItemLog.where(type: "COPY_CARDS").first
        expect(first_card_order_item.activated_at.to_time).to be_within(1.second).of(Time.zone.now)
      end
    end

  end
end
