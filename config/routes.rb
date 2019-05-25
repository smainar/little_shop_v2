Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  resources :items, only: [:index, :show]

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  get '/profile', to: "users#show"
  patch '/profile', to: "users#update"
  get '/profile/edit', to: "users#edit"

  scope :profile, module: :user, as: :user do
    resources :orders, only: :index
  end

  get '/register', to: "users#new"
  get '/dashboard', to: "merchants#show"
  get '/merchants', to: "merchants#index"

  resources :carts, only: :create
  get '/cart', to: "carts#show"
  delete '/cart', to: "carts#destroy"
  post '/cart', to: 'carts#checkout'

  post '/cart/:id', to: 'carts#add_from_show_page',  as: :add_to_cart
  patch '/cart/:id/increment', to: 'carts#increment', as: :increment
  patch '/cart/:id/decrement', to: 'carts#decrement', as: :decrement
  patch '/cart/:id/remove', to: 'carts#remove', as: :remove


  resources :users, only: [:create]

  namespace :admin do
    get '/dashboard', to: "users#show"
  end

  scope :dashboard, module: :merchant, as: :merchant do
    resources :items, only: [:index]
  end
end
