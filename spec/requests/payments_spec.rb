# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payments", type: :request do
  let(:transient_registration) { create(:transient_registration) }

  describe "GET /bo/transient-registrations/:reg_identifier/payments" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/payments" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          reg_identifier: transient_registration.reg_identifier,
          payment_type: "transfer"
        }
      end

      context "when the payment_type is cash" do
        before do
          params[:payment_type] = "cash"
        end

        it "redirects to the cash payment form" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments", payment_form: params
          expect(response).to redirect_to(new_transient_registration_cash_payment_form_path)
        end
      end

      context "when the payment_type is transfer" do
        before do
          params[:payment_type] = "transfer"
        end

        it "redirects to the transfer payment form" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments", payment_form: params
          expect(response).to redirect_to(new_transient_registration_transfer_payment_form_path)
        end
      end

      context "when the payment_type is cheque" do
        before do
          params[:payment_type] = "cheque"
        end

        it "redirects to the cheque payment form" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments", payment_form: params
          expect(response).to redirect_to(new_transient_registration_cheque_payment_form_path)
        end
      end

      context "when the payment_type is postal_order" do
        before do
          params[:payment_type] = "postal_order"
        end

        it "redirects to the postal order payment form" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments", payment_form: params
          expect(response).to redirect_to(new_transient_registration_postal_order_payment_form_path)
        end
      end

      context "when the payment_type is not recognised" do
        before do
          params[:payment_type] = "foo"
        end

        it "renders the new template" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments", payment_form: params
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
