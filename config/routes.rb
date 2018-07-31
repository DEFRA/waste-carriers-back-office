Rails.application.routes.draw do
  mount WasteCarriersEngine::Engine => "/"

  resource :dashboards, only: :index

  root "dashboards#index"

  devise_for :users
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
end
