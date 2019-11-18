# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferService do
  let(:registration) { create(:registration) }
  let(:recipient_email) { external_user.email }

  let(:run_service) do
    RegistrationTransferService.run(registration: registration, email: recipient_email)
  end

  describe "#run" do
    let(:external_user) { create(:external_user) }

    context "when there is an external user with a matching email" do
      it "updates the registration's account_email" do
        run_service
        expect(registration.reload.account_email).to eq(recipient_email)
      end

      context "when there is a transient_registration" do
        let(:transient_registration) do
          create(:renewing_registration, :ready_to_renew)
        end

        let(:registration) do
          WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
        end

        it "updates the transient_registration's account_email" do
          run_service
          expect(transient_registration.reload.account_email).to eq(recipient_email)
        end
      end

      it "sends an email" do
        old_emails_sent_count = ActionMailer::Base.deliveries.count
        run_service
        expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 1)
      end

      it "sends an email to the correct address" do
        run_service
        last_delivery = ActionMailer::Base.deliveries.last
        expect(last_delivery.header["to"].value).to eq(recipient_email)
      end

      it "returns :success_existing_user" do
        expect(run_service).to eq(:success_existing_user)
      end

      context "when the mailer encounters an error" do
        before do
          allow(RegistrationTransferMailer).to receive(:transfer_to_existing_account_email).and_raise(StandardError)
        end

        it "returns :success_existing_user" do
          expect(run_service).to eq(:success_existing_user)
        end
      end
    end

    context "when there is no external user with a matching email" do
      let(:recipient_email) { attributes_for(:external_user)[:email] }

      it "creates a new user" do
        old_matching_user_count = ExternalUser.where(email: recipient_email).length
        run_service
        expect(ExternalUser.where(email: recipient_email).length).to eq(old_matching_user_count + 1)
      end

      it "updates the registration's account_email" do
        run_service
        expect(registration.reload.account_email).to eq(recipient_email)
      end

      context "when there is a transient_registration" do
        let(:transient_registration) do
          create(:renewing_registration, :ready_to_renew)
        end

        let(:registration) do
          WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
        end

        it "updates the transient_registration's account_email" do
          run_service
          expect(transient_registration.reload.account_email).to eq(recipient_email)
        end
      end

      it "sends an email" do
        old_emails_sent_count = ActionMailer::Base.deliveries.count
        run_service
        expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 1)
      end

      it "sends an email to the correct address" do
        run_service
        last_delivery = ActionMailer::Base.deliveries.last
        expect(last_delivery.header["to"].value).to eq(recipient_email)
      end

      it "returns :success_new_user" do
        expect(run_service).to eq(:success_new_user)
      end
    end

    context "when the email is nil" do
      let(:recipient_email) { nil }

      it "returns :no_matching_user" do
        expect(run_service).to eq(:no_matching_user)
      end
    end
  end
end
