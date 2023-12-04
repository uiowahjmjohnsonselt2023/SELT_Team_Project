Rails.application.routes.draw do
  resources :products, :user

  resources :carts, only: %i[show destroy update]
  resources :images

  resources :cart_items, only: %i[create update destroy]

  resources :signup, only: %i[new create]
  resources :sessions, only: %i[new create]

  root 'products#index'

  # cart routes
  post '/cart/:product_id', to: 'carts#add', as: 'add_to_cart'
  post 'carts/:id/remove/:product_id' => 'carts#remove'

  # product routes
  post 'products/create' => 'products#create'
  post 'products/search' => 'products#search', as: :product_search
  get 'products/new' => 'products#new'  

  # User routes
  get 'signup' => 'signup#new'
  get 'signup_succes', to: 'pages#signup_success', as: :signup_success
  get 'logout', to: 'sessions#destroy'

  get 'auth/github/callback', to: 'sessions#SSO'
end
