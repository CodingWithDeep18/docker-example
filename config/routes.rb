Rails.application.routes.draw do
  get 'main_dashboard/index'
  get 'up' => 'rails/health#show', as: :rails_health_check
  # root 'products#index'
  resources :products
  root 'main_dashboard#index'

  resources :payments, only: %i[new]

  post '/create-session', to: 'payments#create_session'
  get '/success', to: 'payments#success'
  get '/cancel', to: 'payments#cancel'
  resources :webhooks, only: [:create]
end
