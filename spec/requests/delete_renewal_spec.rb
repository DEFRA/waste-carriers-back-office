# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Delete renewal", type: :request do
  describe "DELETE /bo/renewing-registrations/:reg_identifier" do

    subject { delete renewing_registration_path(registration.reg_identifier) }

    RSpec.shared_examples "all restart renewal requests" do

      it "redirects to the same page" do
        subject
        expect(response.status).to eq 302
        expect(response.location).to end_with registration_path(registration.reg_identifier)
      end
    end

    let(:user) { create(:user) }
    # Force creation of the registration before calling subject so that the check for changes to Registration.count is valid
    let!(:registration) { create(:registration) }

    before { sign_in(user) }

    context "with no renewal in progress" do
      it_behaves_like "all restart renewal requests"

      it "does not delete any registrations or transient_registrations" do
        expect { subject }.not_to change { WasteCarriersEngine::Registration.count }
        expect { subject }.not_to change { WasteCarriersEngine::TransientRegistration.count }
      end
    end

    context "with a renewal in progress" do
      let(:renewing_registration) { create(:renewing_registration) }

      before { registration.reg_identifier = renewing_registration.reg_identifier }

      it_behaves_like "all restart renewal requests"

      it "deletes the renewing registration" do
        expect { subject }.to change { WasteCarriersEngine::RenewingRegistration.count }.from(1).to(0)
      end
    end
  end
end
