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

  patch '/profile/orders/:id', to: 'user/orders#cancel', as: :cancel_order

  get '/register', to: "users#new"
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
    resources :users, only: [:index]
  end

  scope :dashboard, module: :merchant, as: :merchant do
    get '/', to: "merchants#show", as: :dashboard
    resources :items, only: [:index, :new, :edit]
    patch '/items/:id/disable', to: "items#disable", as: :disable_item
    patch '/items/:id/enable', to: "items#enable", as: :enable_item
    delete '/items/:id', to: "items#destroy", as: :delete_item
  end
end
