require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'main_dashboard#index'
  get 'main_dashboard/index'
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :products do
    collection do
      get :add
      post :import
    end
  end
  resources :payments, only: %i[new]

  post '/create-session', to: 'payments#create_session'
  get '/success', to: 'payments#success'
  get '/cancel', to: 'payments#cancel'
  resources :webhooks, only: [:create]
  resources :orders do
    collection do
      post :create_payment
    end
  end
  resources :carts, only: [] do
    collection do
      post :add
    end
  end
end
