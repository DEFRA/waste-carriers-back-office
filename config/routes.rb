Rails.application.routes.draw do

  get "/bo" => "dashboards#index"

  get "/bo/registrations" => "waste_carriers_engine/registrations#index"

  root to: "application#redirect_root_to_dashboard"

  devise_for :users, path: "/bo/users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "/bo" => "dashboards#index"

  resources :transient_registrations,
            only: :show,
            param: :reg_identifier,
            path: "/bo/transient-registrations",
            path_names: { show: "/:reg_identifier" }

  mount WasteCarriersEngine::Engine => "/bo"
end
