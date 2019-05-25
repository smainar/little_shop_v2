Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  resources :items, only: [:index, :show]

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  get '/profile', to: "users#show" # to-do: move to "user/users#show" using the profile scope / user module
  patch '/profile', to: "users#update" # to-do: move to "user/users#update" using the profile scope / user module
  get '/profile/edit', to: "users#edit" # to-do: move to "user/users#edit" using the profile scope / user module

  scope :profile, module: :user, as: :user do
    resources :orders, only: [:index, :show]
  end


  get '/register', to: "users#new"
  get '/dashboard', to: "merchants#show"
  get '/merchants', to: "merchants#index"

  resources :carts, only: :create
  get '/cart', to: "carts#show"
  delete '/cart', to: "carts#destroy"
  post '/cart', to: 'carts#checkout'

  resources :users, only: [:create]

  namespace :admin do
    get '/dashboard', to: "users#show"
  end

  scope :dashboard, module: :merchant, as: :merchant do
    resources :items, only: [:index]
  end
end
