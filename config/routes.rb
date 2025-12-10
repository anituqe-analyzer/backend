Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  # API routes
  namespace :api do
    namespace :v1 do
      post "login", to: "authentication#login"
      get "user", to: "users#show"
      patch "user", to: "users#update"
      put "user", to: "users#update"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
