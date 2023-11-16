Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'products#index'
  resources :products

  resources :payments, only: %i[new]

  post '/create-session', to: 'payments#create_session'
  get '/success', to: 'payments#success'
  get '/cancel', to: 'payments#cancel'
  resources :webhooks, only: [:create]
end
