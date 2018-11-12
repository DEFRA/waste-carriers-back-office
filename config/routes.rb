Rails.application.routes.draw do

  root to: "application#redirect_root_to_dashboard"

  devise_for :users,
             controllers: { sessions: "sessions" },
             path: "/bo/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" },
             skip: [:invitations]

  get "/bo" => "dashboards#index"

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

  mount WasteCarriersEngine::Engine => "/bo"
end
