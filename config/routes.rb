Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v0 do
      resources :teas, only: [:index]

      resources :customer_subscriptions, only: [:create] do
        patch :cancel, on: :collection, as: :cancel
      end

      resources :customers, only: [] do
        resources :subscriptions, only: [:index], :controller => "customer_subscriptions"
      end
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
