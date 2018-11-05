# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferService do
  let(:transient_registration) do
    create(:transient_registration, :ready_to_renew)
  end

  let(:registration) do
    WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
  end

  let(:registration_transfer_service) do
    RegistrationTransferService.new(registration)
  end

  describe "#initialize" do
    context "when a transient_registration exists" do
      it "sets @transient_registration" do
        instance_var = registration_transfer_service.instance_variable_get(:@transient_registration)
        expect(instance_var).to eq(transient_registration)
      end
    end

    context "when no transient_registration exists" do
      let(:registration_transfer_service) do
        RegistrationTransferService.new(create(:registration))
      end

      it "sets @transient_registration to nil" do
        instance_var = registration_transfer_service.instance_variable_get(:@transient_registration)
        expect(instance_var).to eq(nil)
      end
    end
  end

  describe "#transfer_to_user" do
    let(:external_user) { create(:external_user) }
    let(:recipient_email) { external_user.email }
    let(:transfer_to_user) { registration_transfer_service.transfer_to_user(recipient_email) }

    context "when there is an external user with a matching email" do
      it "updates the registration's account_email" do
        transfer_to_user
        expect(registration.reload.account_email).to eq(recipient_email)
      end

      it "updates the transient_registration's account_email" do
        transfer_to_user
        expect(transient_registration.reload.account_email).to eq(recipient_email)
      end

      it "sends an email" do
        old_emails_sent_count = ActionMailer::Base.deliveries.count
        transfer_to_user
        expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 1)
      end

      it "sends an email to the correct address" do
        transfer_to_user
        last_delivery = ActionMailer::Base.deliveries.last
        expect(last_delivery.header["to"].value).to eq(recipient_email)
      end

      it "returns :success_existing_user" do
        expect(transfer_to_user).to eq(:success_existing_user)
      end

      context "when the mailer encounters an error" do
        before do
          allow(RegistrationTransferMailer).to receive(:transfer_to_existing_account_email).and_raise(StandardError)
        end

        it "returns :success_existing_user" do
          expect(transfer_to_user).to eq(:success_existing_user)
        end
      end
    end

    context "when there is no external user with a matching email" do
      let(:recipient_email) { attributes_for(:external_user)[:email] }

      it "creates a new user" do
        old_matching_user_count = ExternalUser.where(email: recipient_email).length
        transfer_to_user
        expect(ExternalUser.where(email: recipient_email).length).to eq(old_matching_user_count + 1)
      end

      it "updates the registration's account_email" do
        transfer_to_user
        expect(registration.reload.account_email).to eq(recipient_email)
      end

      it "updates the transient_registration's account_email" do
        transfer_to_user
        expect(transient_registration.reload.account_email).to eq(recipient_email)
      end

      it "sends an email" do
        old_emails_sent_count = ActionMailer::Base.deliveries.count
        transfer_to_user
        expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 1)
      end

      it "sends an email to the correct address" do
        transfer_to_user
        last_delivery = ActionMailer::Base.deliveries.last
        expect(last_delivery.header["to"].value).to eq(recipient_email)
      end

      it "returns :success_new_user" do
        expect(transfer_to_user).to eq(:success_new_user)
      end
    end

    context "when the email is nil" do
      let(:recipient_email) { nil }

      it "returns :no_matching_user" do
        expect(registration_transfer_service.transfer_to_user(recipient_email)).to eq(:no_matching_user)
      end
    end
  end
end
