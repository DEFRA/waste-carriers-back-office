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
    let(:existing_user) { create(:external_user) }
    let(:recipient_email) { existing_user.email }

    let(:recipient_user_instance_variable) do
      registration_transfer_service.instance_variable_get(:@recipient_user)
    end

    before do
      registration_transfer_service.transfer_to_user(recipient_email)
    end

    context "when there is an external user with a matching email" do
      it "sets @recipient_user" do
        expect(recipient_user_instance_variable).to eq(existing_user)
      end

      it "updates the registration's account_email" do
        expect(registration.reload.account_email).to eq(recipient_email)
      end

      it "updates the transient_registration's account_email" do
        expect(transient_registration.reload.account_email).to eq(recipient_email)
      end
    end

    context "when there is no external user with a matching email" do
      let(:recipient_email) { "unused-email@example.com" }

      it "sets @recipient_user to nil" do
        expect(recipient_user_instance_variable).to eq(nil)
      end

      it "returns :no_matching_user" do
        expect(registration_transfer_service.transfer_to_user(recipient_email)).to eq(:no_matching_user)
      end
    end

    context "when the email is nil" do
      let(:recipient_email) { nil }

      it "sets @recipient_user to nil" do
        expect(recipient_user_instance_variable).to eq(nil)
      end

      it "returns :no_matching_user" do
        expect(registration_transfer_service.transfer_to_user(recipient_email)).to eq(:no_matching_user)
      end
    end
  end
end
