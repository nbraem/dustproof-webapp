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

  # Public routes
  namespace :public do
    resources :devices, only: :show do
      resources :average_hourly_measurements, only: :index
      resources :average_daily_measurements, only: :index
      resources :measurements, only: [:index, :show]
    end
  end

  # Static pages
  get "/contact", to: "contacts#new"
  get "/hoe", to: "pages#how"
  get "/richtlijnen", to: "pages#guidelines"
  get "/metingen", to: "pages#measurements"
  get "/over-ons", to: "pages#about"

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
      delete :destroy_photo
      get :dust_level
      get :loss
    end
  end
  resources :losses

  root to: redirect("/users/sign_in")
end
