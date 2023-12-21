# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  get "copy_cards_order_completed_forms/new"
  get "copy_cards_order_completed_forms/create"
  get "renewal_received_pending_conviction_forms/new"
  get "renewal_received_pending_conviction_forms/create"
  get "renewal_complete_forms/new"
  get "renewal_complete_forms/create"
  get "registration_received_pending_conviction_forms/new"
  get "registration_completed_forms/new"
  root to: "application#redirect_root_to_dashboard"

  scope "/bo" do
    namespace(
      :api,
      defaults: { format: :json },
      constraints: ->(_request) { WasteCarriersEngine::FeatureToggle.active?(:api) }
    ) do
      resources :registrations, only: %i[show create]
      resources :renewals, only: :show
    end

    get "/resend-confirmation-email/:reg_identifier",
        to: "resend_confirmation_email#new",
        as: "resend_confirmation_email"

    get "/resend-renewal-email/:reg_identifier",
        to: "resend_renewal_email#new",
        as: "resend_renewal_email"

    scope "/:token" do
      #  override the default payment form routes from engine

      resources :payment_method_confirmation_forms,
                only: %i[new create],
                path: "payment-method-confirmation",
                path_names: { new: "" }

      resources :edit_payment_summary_forms,
                only: %i[new create],
                path: "edit-payment",
                path_names: { new: "" } do
                  get "back",
                      to: "edit_payment_summary_forms#go_back",
                      as: "back",
                      on: :collection
                end

      resources :copy_cards_payment_forms,
                only: %i[new create],
                path: "order-copy-cards-payment",
                path_names: { new: "" } do
                  get "back",
                      to: "copy_cards_payment_forms#go_back",
                      as: "back",
                      on: :collection
                end

      #  override the default payment completed form routes from engine
      resources :registration_completed_forms,
                only: :new,
                path: "registration-completed",
                path_names: { new: "" }

      resources :registration_received_pending_conviction_forms,
                only: :new,
                path: "registration-received",
                path_names: { new: "" }

      resources :renewal_complete_forms,
                only: %i[new create],
                path: "renewal-complete",
                path_names: { new: "" }

      resources :renewal_received_pending_conviction_forms,
                only: %i[new create],
                path: "renewal-received",
                path_names: { new: "" }

      # Order copy cards flow
      resources :copy_cards_forms,
                only: %i[new create],
                path: "order-copy-cards",
                path_names: { new: "" }

      resources :copy_cards_bank_transfer_forms,
                only: %i[new create],
                path: "order-copy-cards-bank-transfer",
                path_names: { new: "" }

      # Order copy cards flow
      resources :copy_cards_forms,
                only: %i[new create],
                path: "order-copy-cards",
                path_names: { new: "" }

      resources :copy_cards_bank_transfer_forms,
                only: %i[new create],
                path: "order-copy-cards-bank-transfer",
                path_names: { new: "" }

      resources :copy_cards_order_completed_forms,
                only: %i[new create],
                path: "order-copy-cards-complete",
                path_names: { new: "" }
      # End of order copy cards flow

      # Ceased or revoked flow
      resources :cease_or_revoke_forms,
                only: %i[new create],
                path: "cease-or-revoke",
                path_names: { new: "" }

      resources :ceased_or_revoked_confirm_forms,
                only: %i[new create],
                path: "ceased-or-revoked-confirm",
                path_names: { new: "" } do
                  get "back",
                      to: "ceased_or_revoked_confirm_forms#go_back",
                      as: "back",
                      on: :collection
                end
      # End of ceased or revoked flow

      # Edit flow
      resources :edit_forms,
                only: %i[new create],
                path: "edit",
                path_names: { new: "" } do
                  get "cbd-type",
                      to: "edit_forms#edit_cbd_type",
                      as: "cbd_type",
                      on: :collection

                  get "company-name",
                      to: "edit_forms#edit_company_name",
                      as: "company_name",
                      on: :collection

                  get "main-people",
                      to: "edit_forms#edit_main_people",
                      as: "main_people",
                      on: :collection

                  get "company-address",
                      to: "edit_forms#edit_company_address",
                      as: "company_address",
                      on: :collection

                  get "contact-name",
                      to: "edit_forms#edit_contact_name",
                      as: "contact_name",
                      on: :collection

                  get "contact-phone",
                      to: "edit_forms#edit_contact_phone",
                      as: "contact_phone",
                      on: :collection

                  get "contact-email",
                      to: "edit_forms#edit_contact_email",
                      as: "contact_email",
                      on: :collection

                  get "contact-address",
                      to: "edit_forms#edit_contact_address",
                      as: "contact_address",
                      on: :collection

                  get "contact-address-reuse",
                      to: "edit_forms#edit_contact_address_reuse",
                      as: "contact_address_reuse",
                      on: :collection

                  get "cancel",
                      to: "edit_forms#cancel",
                      as: "cancel",
                      on: :collection
                end

      resources :edit_bank_transfer_forms,
                only: %i[new create],
                path: "edit-bank-transfer",
                path_names: { new: "" }

      resources :edit_complete_forms,
                only: %i[new create],
                path: "edit-complete",
                path_names: { new: "" }

      resources :confirm_edit_cancelled_forms,
                only: %i[new create],
                path: "confirm-edit-cancelled",
                path_names: { new: "" }

      resources :edit_cancelled_forms,
                only: %i[new create],
                path: "edit-cancelled",
                path_names: { new: "" }
      # End of edit flow

    end
  end

  devise_for :users,
             controllers: { invitations: "user_invitations", sessions: "sessions" },
             path: "/bo/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "/bo" => "dashboards#index"
  get "/bo/convictions" => "convictions_dashboards#index", as: :convictions
  get "/bo/convictions/possible-matches" => "convictions_dashboards#possible_matches", as: :convictions_possible_matches
  get "/bo/convictions/in-progress" => "convictions_dashboards#checks_in_progress", as: :convictions_checks_in_progress
  get "/bo/convictions/approved" => "convictions_dashboards#approved", as: :convictions_approved
  get "/bo/convictions/rejected" => "convictions_dashboards#rejected", as: :convictions_rejected

  # Privacy policy
  get "/bo/ad-privacy-policy", to: "ad_privacy_policy#show", as: :ad_privacy_policy

  resources :resources,
            only: [],
            path: "/bo/resources" do
    resources :refunds,
              only: %i[index new create update],
              param: :order_key

    resources :cancels,
              only: %i[new create],
              path_names: { new: "" }

    resources :reversal_forms,
              only: %i[index new create],
              path: "reversals",
              path_names: { new: ":order_key/new" },
              param: :order_key

    resources :payment_forms,
              only: %i[new create],
              path: "payments",
              path_names: { new: "" }

    resources :cash_payment_forms,
              only: %i[new create],
              path: "payments/cash",
              path_names: { new: "" }

    resources :cheque_payment_forms,
              only: %i[new create],
              path: "payments/cheque",
              path_names: { new: "" }

    resources :postal_order_payment_forms,
              only: %i[new create],
              path: "payments/postal-order",
              path_names: { new: "" }

    resources :bank_transfer_payment_forms,
              only: %i[new create],
              path: "payments/bank-transfer",
              path_names: { new: "" }

    resources :missed_card_payment_forms,
              only: %i[new create],
              path: "payments/missed-card-payment",
              path_names: { new: "" }

    resources :missed_card_payment_new_registrations,
              only: :new,
              path: "missed-card-payment-new-registration",
              path_names: { new: "" }

    resource :finance_details,
             only: :show,
             path: "finance-details"

    resource :write_off_form,
             only: %i[new create],
             path: "write-off"

    resource :charge_adjust_form,
             only: %i[new create],
             path: "payments/charge-adjusts",
             path_names: { new: "" }

    resource :negative_charge_adjust_form,
             only: %i[new create],
             path: "payments/charge-adjust/negative",
             path_names: { new: "" }

    resource :positive_charge_adjust_form,
             only: %i[new create],
             path: "payments/charge-adjust/positive",
             path_names: { new: "" }
  end

  resources :new_registrations,
            only: :show,
            param: :token,
            path: "/bo/new-registrations"

  resources :renewing_registrations,
            only: :show,
            param: :reg_identifier,
            path: "/bo/renewing-registrations"

  resources :registrations,
            only: :show,
            param: :reg_identifier,
            path: "/bo/registrations" do
              resources :convictions,
                        only: :index

              resources :registration_conviction_approval_forms,
                        only: %i[new create],
                        path: "convictions/approve",
                        path_names: { new: "" }

              resources :registration_conviction_rejection_forms,
                        only: %i[new create],
                        path: "convictions/reject",
                        path_names: { new: "" }

              resources :registration_transfers,
                        only: %i[new create],
                        param: :reg_identifier,
                        path: "transfer",
                        path_names: { new: "" }

              resources :registration_restores,
                        only: %i[new create],
                        param: :reg_identifier,
                        path: "restore",
                        path_names: { new: "" }

              get "transfer/success",
                  to: "registration_transfers#success",
                  as: :registration_transfer_success

              get "certificate", to: "certificates#show", as: :certificate

              get "communication_records", to: "communication_records#index", as: :communication_records
            end

  resources :card_order_exports,
            only: %i[show index],
            path: "/bo/card-order-exports"

  resources :transient_registrations,
            only: [],
            param: :reg_identifier,
            path: "/bo/transient-registrations",
            path_names: { show: "/:reg_identifier" } do
              resources :convictions,
                        only: :index

              resources :conviction_approval_forms,
                        only: %i[new create],
                        path: "convictions/approve",
                        path_names: { new: "" }

              resources :conviction_rejection_forms,
                        only: %i[new create],
                        path: "convictions/reject",
                        path_names: { new: "" }
            end

  get "/bo/registrations/:registration_reg_identifier/convictions/begin-checks",
      to: "convictions#begin_checks",
      as: :registration_convictions_begin_checks

  patch "/bo/registrations/:reg_identifier/companies_house_details",
        to: "refresh_companies_house_name#update_companies_house_details",
        as: :refresh_companies_house_name

  patch "/bo/registrations/:reg_identifier/ea_area",
        to: "refresh_ea_area#update_ea_area",
        as: :refresh_ea_area

  get "/bo/transient-registrations/:transient_registration_reg_identifier/convictions/begin-checks",
      to: "convictions#begin_checks",
      as: :transient_registration_convictions_begin_checks

  delete "/bo/renewing-registrations/:reg_identifier",
         to: "renewing_registrations#destroy",
         as: :renewing_registration_destroy

  get "/bo/users",
      to: "users#index",
      as: :users

  resources :users,
            only: [],
            path: "/bo/users" do
              collection do
                get :all
              end

              resources :user_activations,
                        as: :activations,
                        only: %i[new create],
                        path: "activate",
                        path_names: { new: "" }

              resources :user_deactivations,
                        as: :deactivations,
                        only: %i[new create],
                        path: "deactivate",
                        path_names: { new: "" }

              resources :user_roles,
                        as: :roles,
                        only: %i[new create],
                        path: "role",
                        path_names: { new: "" }
            end

  resources :conviction_imports,
            only: %i[new create],
            path: "/bo/import-convictions",
            path_names: { new: "" }

  resource :finance_reports,
           only: %i[show],
           path: "/bo/reports/download_finance_reports"

  resource :quarterly_reports,
           only: %i[show],
           path: "/bo/reports/quarterly_reports"

  resource :email_exports,
           only: %i[new create show],
           path: "/bo/email-exports"

  resource :email_exports_list,
           only: %i[new],
           path: "/bo/email-exports-list"

  resources :analytics,
            only: %i[index],
            path: "/bo/analytics"

  # Redirect old Devise routes
  get "/agency_users(*all)" => redirect("/bo/users%{all}")
  get "/admins(*all)" => redirect("/bo/users%{all}")

  mount DefraRubyMocks::Engine => "/bo/mocks"

  mount DefraRubyFeatures::Engine => "/bo/features", as: "features_engine"

  mount WasteCarriersEngine::Engine => "/bo", as: "basic_app_engine"

end
# rubocop:enable Metrics/BlockLength
