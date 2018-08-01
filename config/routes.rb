Rails.application.routes.draw do
  mount WasteCarriersEngine::Engine => "/bo"

  resource :dashboards, only: :index

  root "dashboards#index"

  devise_for :users, path: "/bo/users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }
end
