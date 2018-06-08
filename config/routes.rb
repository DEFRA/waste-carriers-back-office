Rails.application.routes.draw do
  resource :dashboards, only: :index

  root "dashboards#index"
end
