Rails.application.routes.draw do
  root "orders#index"
  resources :orders, only: :index
  post "orders/upload", to: "orders#upload"
end
