# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationRestoreForms" do

  let(:registration) { create(:registration, :revoked) }

  describe "GET /bo/registrations/:_id/restore" do

    context "when a user is not signed in" do

      before { get new_registration_registration_restore_path(registration.reg_identifier) }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }

      before do
        sign_in(user)
        get new_registration_registration_restore_path(registration.reg_identifier)
      end

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "POST /bo/registrations/:_id/restore" do

    context "when a user is not signed in" do

      before { post new_registration_registration_restore_path(registration.reg_identifier) }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when a valid user is signed in" do

      subject(:restore_reg) do
        post new_registration_registration_restore_path(registration.reg_identifier),
             params: { registration_restore_form: { restored_reason: restored_reason } }
      end

      let(:user) { create(:user, role: :agency_with_refund) }

      before { sign_in(user) }

      context "without a restored_reason" do
        let(:restored_reason) { nil }

        it "does not modify the registration" do
          expect { restore_reg }.not_to change { registration.metaData.lastModified }
        end
      end

      context "with a restored_reason" do
        let(:restored_reason) { "because" }

        it "reactivates the registration" do
          expect { restore_reg }.to change { registration.reload.metaData.status }.to("ACTIVE")
        end

        it "stores the restoration reason" do
          expect { restore_reg }.to change { registration.reload.metaData.restored_reason }.to(restored_reason)
        end

        it "stores the email of the user who restored the registration" do
          expect { restore_reg }.to change { registration.reload.metaData.restored_by }.to(user.email)
        end
      end
    end
  end
end
