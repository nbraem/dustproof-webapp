Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { registrations: "users/registrations" }
  devise_scope :user do
    authenticated :user do
      root to: "devices#index", as: :authenticated_root
    end
  end

  # Admin routes
  scope "/admin" do
    resources :users
    resources :incoming_messages do
      collection do
        delete :destroy_all
      end
    end
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :measurements, only: [:index, :create]
    end
  end

  # Static pages
  get "/contact", to: "contacts#new"
  get "/hoe", to: "pages#how"
  get "/richtlijnen", to: "pages#guidelines"
  get "/metingen", to: "pages#measurements"
  get "/over-ons", to: "pages#about"
  get "/dust_level", to: "pages#dust_level"

  # Contact form
  resources :contacts, only: [:new, :create]

  # Other resources
  resources :devices do
    resources :average_hourly_measurements
    resources :average_daily_measurements
    resources :measurements do
      collection do
        delete :destroy_all
      end
    end
    member do
      put :regenerate_api_key
    end
  end
  resources :wifi_metrics
  resources :lora_metrics

  root "pages#home"
end
