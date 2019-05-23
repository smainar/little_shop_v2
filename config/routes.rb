Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  resources :items, only: [:index, :show]

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  get '/profile', to: "users#show"
  get '/profile/edit', to: "users#edit"
  get '/register', to: "users#new"
  get '/dashboard', to: "merchants#show"
  get '/merchants', to: "merchants#index"

  resources :carts, only: [:create]
  get '/cart', to: "carts#show"
  delete '/cart', to: "carts#destroy"

  resources :users, only: [:create]

  namespace :admin do
    get '/dashboard', to: "users#show"
  end
end
