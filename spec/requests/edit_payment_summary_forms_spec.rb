# frozen_string_literal: true

require "rails_helper"

RSpec.describe "EditPaymentSummaryForms" do
  describe "GET new_edit_payment_summary_form_path" do
    context "when a user is signed in" do
      let(:user) { create(:user, role: :agency_super) }
      let(:transient_registration) do
        create(:edit_registration, finance_details: build(:finance_details, :has_paid_order_and_payment))
      end
      let(:call_recording_service) { instance_spy(CallRecordingService) }

      before do
        sign_in(user)
        allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:additional_debug_logging)
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording)
      end

      context "when no matching registration exists" do
        it "redirects to the invalid token error page" do
          get new_edit_payment_summary_form_path("CBDU999999999")
          expect(response).to redirect_to(page_path("invalid"))
        end
      end

      context "when a matching registration exists" do
        let(:path) { new_edit_payment_summary_form_path(transient_registration.token) }
        let(:transient_registration) do
          create(:edit_registration,
                 :has_finance_details,
                 workflow_state: "edit_payment_summary_form")
        end

        it "renders the appropriate template and responds with a 200 status code" do
          get path

          expect(response).to render_template("edit_payment_summary_forms/new")
          expect(response).to have_http_status(:ok)
        end

        context "when the call recording feature flag is on" do
          before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true) }

          it_behaves_like "pauses call recording"
        end

        context "when the call recording feature flag is off" do
          before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false) }

          it "does not pause call recording" do
            expect(call_recording_service).not_to have_received(:pause)
          end
        end

        context "when it already has a finance_details" do
          it "does not modify the finance_details" do
            expect { get path }.not_to change(transient_registration, :finance_details)
          end
        end

        context "when it does not have a finance_details" do
          let(:transient_registration) do
            create(:edit_registration,
                   :has_changed_registration_type,
                   workflow_state: "edit_payment_summary_form")
          end

          it "creates a new finance_details" do
            expect(transient_registration.finance_details).to be_nil

            get path

            expect(transient_registration.reload.finance_details).not_to be_nil
          end
        end
      end
    end
  end

  describe "POST edit_payment_summary_forms_path" do
    context "when a user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when no matching registration exists" do
        it "does not create a new transient registration and redirects to the invalid page" do
          original_tr_count = EditRegistration.count

          post edit_payment_summary_forms_path(token: "CBDU222")

          expect(response).to redirect_to(page_path("invalid"))
          expect(EditRegistration.count).to eq(original_tr_count)
        end
      end

      context "when a matching registration exists" do
        let(:path) { edit_payment_summary_forms_path(token: transient_registration.token) }
        let(:transient_registration) { create(:edit_registration, :has_finance_details, workflow_state: "edit_payment_summary_form") }

        context "when valid params are submitted" do
          let(:valid_params) { { temp_payment_method: temp_payment_method } }

          context "when the temp payment method is `card`" do
            let(:temp_payment_method) { "card" }

            it "updates the transient registration with correct data, returns a 302 response and redirects to the govpay form" do
              post path, params: { edit_payment_summary_form: valid_params }

              transient_registration.reload

              expect(transient_registration.temp_payment_method).to eq("card")
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to(WasteCarriersEngine::Engine.routes.url_helpers.new_govpay_form_path(transient_registration.token))
            end
          end

          context "when the temp payment method is `bank_transfer`" do
            let(:temp_payment_method) { "bank_transfer" }

            it "updates the transient registration with correct data, returns a 302 response and redirects to the bank transfer form" do
              post path, params: { edit_payment_summary_form: valid_params }

              transient_registration.reload

              expect(transient_registration.temp_payment_method).to eq("bank_transfer")
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to(new_edit_bank_transfer_form_path(transient_registration.token))
            end
          end
        end

        context "when invalid params are submitted" do
          let(:invalid_params) { { temp_payment_method: "foo" } }

          it "returns a 200 response and render the new copy cards form" do
            post path, params: { edit_payment_summary_form: invalid_params }

            expect(response).to have_http_status(:ok)
            expect(response).to render_template("edit_payment_summary_forms/new")
          end
        end
      end
    end
  end
end
