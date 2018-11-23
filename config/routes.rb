Rails.application.routes.draw do

  root to: "application#redirect_root_to_dashboard"

  devise_for :users,
             controllers: { sessions: "sessions" },
             path: "/bo/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" },
             skip: [:invitations]

  get "/bo" => "dashboards#index"
  get "/bo/convictions" => "convictions_dashboards#index", as: :convictions
  get "/bo/convictions/possible-matches" => "convictions_dashboards#possible_matches", as: :convictions_possible_matches
  get "/bo/convictions/in-progress" => "convictions_dashboards#checks_in_progress", as: :convictions_checks_in_progress
  get "/bo/convictions/approved" => "convictions_dashboards#approved", as: :convictions_approved
  get "/bo/convictions/rejected" => "convictions_dashboards#rejected", as: :convictions_rejected

  resources :transient_registrations,
            only: :show,
            param: :reg_identifier,
            path: "/bo/transient-registrations",
            path_names: { show: "/:reg_identifier" } do
              resources :convictions,
                        only: :index

              resources :conviction_approval_forms,
                        only: [:new, :create],
                        path: "convictions/approve",
                        path_names: { new: "" }

              resources :conviction_rejection_forms,
                        only: [:new, :create],
                        path: "convictions/reject",
                        path_names: { new: "" }

              resources :payments,
                        only: [:new, :create],
                        path_names: { new: "" }

              resources :cash_payment_forms,
                        only: [:new, :create],
                        path: "payments/cash",
                        path_names: { new: "" }

              resources :cheque_payment_forms,
                        only: [:new, :create],
                        path: "payments/cheque",
                        path_names: { new: "" }

               resources :postal_order_payment_forms,
                        only: [:new, :create],
                        path: "payments/postal-order",
                        path_names: { new: "" }

              resources :transfer_payment_forms,
                        only: [:new, :create],
                        path: "payments/transfer",
                        path_names: { new: "" }

              resources :worldpay_escapes,
                        only: :new,
                        path: "revert-to-payment-summary",
                        path_names: { new: "" }

              resources :worldpay_missed_payment_forms,
                        only: [:new, :create],
                        path: "payments/worldpay-missed",
                        path_names: { new: "" }
            end

  resources :registration_transfers,
            only: [:new, :create],
            param: :reg_identifier,
            path: "/bo/transfer-registration",
            path_names: { new: "/:reg_identifier" }
  get "/bo/transfer-registration/:reg_identifier/success",
      to: "registration_transfers#success",
      as: :registration_transfer_success

  get "/bo/users",
      to: "users#index",
      as: :users

  resources :user_migrations,
        only: [:new, :create],
        path: "/bo/users/migrate",
        path_names: { new: "" }

  get "/bo/users/migrate/results",
    to: "user_migrations#results",
    as: :user_migration_results

  mount WasteCarriersEngine::Engine => "/bo"
end
