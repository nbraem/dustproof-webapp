Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { registrations: "users/registrations" }
  devise_scope :user do
    authenticated :user do
      root to: "measurements#index", as: :authenticated_root
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

  # Contact form
  resources :contacts, only: [:new, :create]

  # Other resources
  resources :measurements do
    collection do
      delete :destroy_all
      get :chart
    end
  end

  # Other actions
  put "/regenerate_api_key", to: "api_key#regenerate_api_key"

  root "pages#home"
end
