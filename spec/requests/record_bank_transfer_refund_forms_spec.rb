# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RecordBankTransferRefundForms" do
  let(:finance_details) { build(:finance_details, :has_double_paid_order_and_payment_bank_transfer) }
  let(:registration) { create(:registration, finance_details: finance_details) }
  let(:payment) { registration.finance_details.payments.first }
  let(:valid_user) { create(:user, role: :finance) }
  let(:invalid_user) { create(:user) }

  shared_examples "requires authentication" do
    context "when user is not signed in" do
      it "redirects to the sign-in page" do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/resources/:_id/record_bank_transfer_refund_forms" do
    subject { get resource_record_bank_transfer_refund_forms_path(registration._id) }

    it_behaves_like "requires authentication"

    context "when a valid user is signed in" do
      before { sign_in(valid_user) }

      it "renders the index template and returns a 200 status" do
        subject
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /bo/resources/:_id/record_bank_transfer_refund_forms/:order_key/new" do
    subject { get new_resource_record_bank_transfer_refund_form_path(registration._id, order_key: payment.order_key) }

    it_behaves_like "requires authentication"

    context "when a valid user is signed in" do
      before { sign_in(valid_user) }

      it "renders the new template and returns a 200 status" do
        subject
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /bo/resources/:_id/record_bank_transfer_refund_forms/:order_key" do
    subject { post resource_record_bank_transfer_refund_forms_path(registration._id, order_key: payment.order_key) }

    it_behaves_like "requires authentication"

    context "when a valid user is signed in" do
      before { sign_in(valid_user) }

      it "creates a refund payment, redirects to the finance details page, and returns a 302 status" do
        expect { subject }.to change { registration.reload.finance_details.payments.count }.by(1)
        expect(response).to redirect_to(resource_finance_details_path(registration._id))
        expect(response).to have_http_status(:found)
      end
    end

    context "when a user with the wrong permissions is signed in" do
      before { sign_in(invalid_user) }

      it "redirects to the permissions page" do
        subject
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end
end
