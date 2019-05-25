Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  resources :items, only: [:index, :show]

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  scope :profile, module: :user, as: :profile do
    get '/', to: "users#show"
    patch '/', to: "users#update"
    get '/edit', to: "users#edit"
  end

  scope :profile, module: :user, as: :user do
    resources :orders, only: [:index, :show]
  end

  get '/register', to: "users#new"
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
    get '/', to: "merchants#show", as: :dashboard
    resources :items, only: [:index]
  end
end
