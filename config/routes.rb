require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :customers
  mount Sidekiq::Web => '/sidekiq'
  root 'main_dashboard#index'
  get 'main_dashboard/index'
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :webhooks, only: [:create]

  resources :products do
    collection do
      get :add
      post :import
    end
  end

  resources :orders do
    collection do
      post :create_payment
      get :success
      get :cancel
    end
  end

  resources :carts, only: [:index] do
    collection do
      post :add
    end
  end
end
