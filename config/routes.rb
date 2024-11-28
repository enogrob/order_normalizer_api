Rails.application.routes.draw do
  resources :orders, only: :index
  post "orders/upload", to: "orders#upload"
end
