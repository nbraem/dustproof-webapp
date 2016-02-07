Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  scope "/admin" do
    resources :users
  end

  get "/contact", to: "contacts#new"
  get "/hoe", to: "pages#how"
  get "/richtlijnen", to: "pages#guidelines"
  get "/metingen", to: "pages#measurements"
  get "/over-ons", to: "pages#about"

  resources :contacts, only: [:new, :create]
  resources :measurements do
    collection do
      delete :destroy_all
    end
  end

  root "pages#home"
end
