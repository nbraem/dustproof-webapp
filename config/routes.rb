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

  root "pages#home"
end
