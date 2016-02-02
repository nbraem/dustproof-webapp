Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  scope "/admin" do
    resources :users
  end

  get "/contact", to: "contacts#new"
  get "/hoe", to: "pages#how"
  get "/metingen", to: "pages#measurements"

  resources :contacts, only: [:new, :create]

  root "pages#home"
end
