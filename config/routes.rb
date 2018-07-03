Rails.application.routes.draw do
  mount WasteCarriersEngine::Engine => "/"

  resource :dashboards, only: :index

  root "dashboards#index"
end
