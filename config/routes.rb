Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v0 do
      resources :teas, only: [:index]

      resources :customer_subscriptions, only: [:create] do
        patch :cancel, on: :collection, as: :cancel
      end

      resources :subscriptions, only: [:create, :update]

      resources :subscription_teas, only: [:create]

      resources :customers, only: [:create, :update] do
        resources :subscriptions, only: [:index], :controller => "customer_subscriptions"
      end
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
