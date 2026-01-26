Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  # API routes
  namespace :api do
    namespace :v1 do
      post "login", to: "authentication#login"

      get "user", to: "users#show"
      patch "user", to: "users#update"
      put "user", to: "users#update"

      resources :categories, only: [ :index, :show ]

      resources :auctions do
        resources :opinions, only: [ :index, :create ]
      end

      resources :opinions, only: [ :show, :update, :destroy ] do
        resource :vote, controller: "opinion_votes", only: [ :create, :destroy ]
      end

      get "validate_url", to: "check_auction#validate"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
