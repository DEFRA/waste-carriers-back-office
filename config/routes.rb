Rails.application.routes.draw do
  mount WasteCarriersEngine::Engine => "/bo"

  get "/bo" => "dashboards#index"

  root "waste_carriers_engine/registrations#index"

  devise_for :users, path: "/bo/users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }
end
