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
end
