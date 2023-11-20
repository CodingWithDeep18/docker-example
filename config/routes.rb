Rails.application.routes.draw do
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
end
