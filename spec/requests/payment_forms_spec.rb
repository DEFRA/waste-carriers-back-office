# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PaymentForms", type: :request do
  let(:transient_registration) { create(:renewing_registration) }

  describe "GET /bo/resources/:_id/payments" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template and returns a 200 response" do
        get "/bo/resources/#{transient_registration._id}/payments"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
      end

      context "when the resource is a registration" do
        let(:registration) { create(:registration) }

        it "renders the new template and returns a 200 response" do
          get "/bo/resources/#{registration._id}/payments"

          expect(response).to render_template(:new)
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe "POST /bo/resources/:_id/payments" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_super) }

      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          payment_type: "transfer"
        }
      end

      context "when the payment_type is cash" do
        before do
          params[:payment_type] = "cash"
        end

        it "redirects to the cash payment form" do
          post "/bo/resources/#{transient_registration._id}/payments", payment_form: params

          expect(response).to redirect_to(new_resource_cash_payment_form_path(transient_registration._id))
        end
      end

      context "when the payment_type is cheque" do
        before do
          params[:payment_type] = "cheque"
        end

        it "redirects to the cheque payment form" do
          post "/bo/resources/#{transient_registration._id}/payments", payment_form: params

          expect(response).to redirect_to(new_resource_cheque_payment_form_path(transient_registration._id))
        end
      end

      context "when the payment_type is postal_order" do
        before do
          params[:payment_type] = "postal_order"
        end

        it "redirects to the postal order payment form" do
          post "/bo/resources/#{transient_registration._id}/payments", payment_form: params

          expect(response).to redirect_to(new_resource_postal_order_payment_form_path(transient_registration._id))
        end
      end

      context "when the payment_type is bank transfer" do
        before do
          params[:payment_type] = "bank_transfer"
        end

        it "redirects to the bank transfer payment form" do
          post "/bo/resources/#{transient_registration._id}/payments", payment_form: params

          expect(response).to redirect_to(new_resource_bank_transfer_payment_form_path(transient_registration._id))
        end
      end

      context "when the payment_type is worldpay_missed" do
        before do
          params[:payment_type] = "worldpay_missed"
        end

        it "redirects to the worldpay_missed payment form" do
          post "/bo/resources/#{transient_registration._id}/payments", payment_form: params

          expect(response).to redirect_to(new_resource_worldpay_missed_payment_form_path(transient_registration._id))
        end
      end

      context "when the payment_type is not recognised" do
        before do
          params[:payment_type] = "foo"
        end

        it "renders the new template" do
          post "/bo/resources/#{transient_registration._id}/payments", payment_form: params

          expect(response).to render_template(:new)
        end
      end
    end
  end
end
