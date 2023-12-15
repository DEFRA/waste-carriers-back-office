# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CopyCardsPaymentForms" do
  describe "GET new_copy_cards_payment_form_path" do
    context "when a user is signed in" do
      let(:user) { create(:user, role: :agency_super) }
      let(:call_recording_service) { instance_spy(CallRecordingService) }

      before do
        sign_in(user)
        allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording)
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:additional_debug_logging)
      end

      context "when no matching registration exists" do
        it "redirects to the invalid token error page" do
          get new_copy_cards_payment_form_path("CBDU999999999")
          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        let(:transient_registration) { create(:order_copy_cards_registration, :has_finance_details, workflow_state: "copy_cards_payment_form") }
        let(:path) { new_copy_cards_payment_form_path(transient_registration.token) }

        it "renders the appropriate template and responds with a 200 status code" do
          get path

          expect(response).to render_template("copy_cards_payment_forms/new")
          expect(response).to have_http_status(:ok)
        end

        context "when call recording feature flag is on" do

          before do
            allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
          end

          it_behaves_like "pauses call recording"
        end

        context "when call recording feature flag is off" do
          before do
            allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
          end

          it "does not pause call recording" do
            expect(call_recording_service).not_to have_received(:pause)
          end
        end
      end
    end

    context "when a user is not signed in" do
      before do
        user = create(:user)
        sign_out(user)
      end

      it "returns a 302 response and redirects to the invalid page" do
        get new_copy_cards_payment_form_path("foo")

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(page_path("invalid"))
      end
    end
  end

  describe "POST copy_cards_payment_forms_path" do
    context "when a user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when no matching registration exists" do
        it "does not create a new transient registration and redirects to the invalid page" do
          original_tr_count = OrderCopyCardsRegistration.count

          post copy_cards_payment_forms_path(token: "CBDU222")

          expect(response).to redirect_to(page_path("invalid"))
          expect(OrderCopyCardsRegistration.count).to eq(original_tr_count)
        end
      end

      context "when a matching registration exists" do
        let(:transient_registration) { create(:order_copy_cards_registration, :has_finance_details, workflow_state: "copy_cards_payment_form") }

        context "when valid params are submitted" do
          let(:valid_params) { { temp_payment_method: temp_payment_method } }

          context "when the temp payment method is `card`" do
            let(:temp_payment_method) { "card" }

            it "updates the transient registration with correct data, returns a 302 response and redirects to the govpay form" do
              post copy_cards_payment_forms_path(token: transient_registration.token), params: { copy_cards_payment_form: valid_params }

              transient_registration.reload

              expect(transient_registration.temp_payment_method).to eq("card")
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_govpay_form_path(transient_registration.token))
            end
          end

          context "when the temp payment method is `bank_transfer`" do
            let(:temp_payment_method) { "bank_transfer" }

            it "updates the transient registration with correct data, returns a 302 response and redirects to the bank transfer form" do
              post copy_cards_payment_forms_path(token: transient_registration.token), params: { copy_cards_payment_form: valid_params }

              transient_registration.reload

              expect(transient_registration.temp_payment_method).to eq("bank_transfer")
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to(new_copy_cards_bank_transfer_form_path(transient_registration.token))
            end
          end
        end

        context "when invalid params are submitted" do
          let(:invalid_params) { { temp_payment_method: "foo" } }

          it "returns a 200 response and render the new copy cards form" do
            post copy_cards_payment_forms_path(token: transient_registration.token), params: { copy_cards_payment_form: invalid_params }

            expect(response).to have_http_status(:ok)
            expect(response).to render_template("copy_cards_payment_forms/new")
          end
        end
      end
    end

    context "when a user is not signed in" do
      before do
        user = create(:user)
        sign_out(user)
      end

      it "returns a 302 response and redirects to an invalid page" do
        post copy_cards_payment_forms_path(token: "1234")

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(page_path("invalid"))
      end
    end
  end
end
