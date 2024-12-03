require 'sidekiq/web'

Rails.application.routes.draw do
  root "orders#index"
  resources :orders, only: :index
  post "orders/upload", to: "orders#upload"
  get "orders/results", to: "orders#results"

  # Mount Sidekiq Web UI
  mount Sidekiq::Web => '/sidekiq'
end
