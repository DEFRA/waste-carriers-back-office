# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionApprovalForms" do
  let(:transient_registration) { create(:renewing_registration, :requires_conviction_check, :no_pending_payment) }
  let(:registration) do
    WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
  end

  describe "GET /bo/transient-registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "renders the new template, returns a 200 response, and includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/convictions/approve" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:params) do
        {
          revoked_reason: "foo"
        }
      end
      let(:renewal_completion_service) { WasteCarriersEngine::RenewalCompletionService.new(transient_registration) }

      before do
        allow(WasteCarriersEngine::RenewalCompletionService).to receive(:new).and_return(renewal_completion_service)

        # Block renewal completion so we can check the values of the transient_registration after submission
        allow(renewal_completion_service).to receive(:delete_transient_registration)

        sign_in(user)
      end

      it "redirects to the convictions page and updates the revoked_reason, workflow_state, and 'confirmed_' attributes" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

        expect(response).to redirect_to(convictions_path)

        expect(transient_registration.reload.metaData.revoked_reason).to eq(params[:revoked_reason])
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("yes")
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed_at).to be_a(DateTime)
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed_by).to eq(user.email)
        expect(transient_registration.reload.conviction_sign_offs.first.workflow_state).to eq("approved")
      end

      context "when there is no pending payment" do
        before { transient_registration.finance_details = build(:finance_details, balance: 0) }

        it "renews the registration" do
          expected_expiry_date = registration.expires_on.to_date + 3.years

          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

          actual_expiry_date = registration.reload.expires_on.to_date

          expect(actual_expiry_date).to eq(expected_expiry_date)
        end

        context "when the RenewalCompletionService fails" do
          before do
            allow(renewal_completion_service).to receive(:complete_renewal).and_raise(StandardError)
          end

          it "rescues the error" do
            expect do
              post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }
            end.not_to raise_error
          end
        end
      end

      context "when there is a pending payment" do
        before { transient_registration.finance_details = build(:finance_details, balance: 100) }

        it "does not renews the registration" do
          old_renewal_date = registration.expires_on

          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

          expect(registration.reload.expires_on).to eq(old_renewal_date)
        end
      end

      context "when the params are invalid" do
        let(:params) do
          {
            revoked_reason: ""
          }
        end

        it "renders the new template, does not update the revoked_reason, and does not update the conviction_sign_off" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

          expect(response).to render_template(:new)
          expect(transient_registration.reload.metaData.revoked_reason).not_to eq(params[:revoked_reason])
          expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }
      let(:params) do
        {
          revoked_reason: "foo"
        }
      end

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page, does not update the revoked_reason, and does not update the conviction_sign_off" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions/approve", params: { conviction_approval_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
        expect(transient_registration.reload.metaData.revoked_reason).not_to eq(params[:revoked_reason])
        expect(transient_registration.reload.conviction_sign_offs.first.confirmed).to eq("no")
      end
    end
  end
end
