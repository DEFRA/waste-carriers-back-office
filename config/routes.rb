Rails.application.routes.draw do
  mount WasteCarriersEngine::Engine => "/bo"

  root "waste_carriers_engine/registrations#index"

  devise_for :users, path: "/bo/users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "/bo" => "dashboards#index"

  resources :transient_registrations,
            only: :show,
            param: :reg_identifier,
            path: "/bo/transient-registrations",
            path_names: { show: "/:reg_identifier" }
end
