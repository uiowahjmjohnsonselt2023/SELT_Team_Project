Rails.application.routes.draw do
  resources :products, :user

  resources :carts, only: %i[show destroy update]
  resources :images

  resources :cart_items, only: %i[create update destroy]
  resources :recent_purchases
  resources :signup, only: %i[new create]
  resources :sessions, only: %i[new create]
  resources :orders, only: %i[show new create] 

  root 'products#index'

  # cart routes
  post '/cart/:product_id', to: 'carts#add', as: 'add_to_cart'
  post '/carts/:id' => 'carts#destroy', as: 'remove_from_cart' 
  put '/carts/:id' => 'carts#update', as: 'update_cart'
  post 'order/:id/checkout' => 'orders#checkout', as: 'checkout'

  # product routes
  post 'products/create' => 'products#create'
  post 'products/search' => 'products#search', as: :product_search
  get 'products/new' => 'products#new'

  # about page route
  get 'about', to: 'pages#about'

  # User routes
  get 'signup' => 'signup#new'
  get 'signup_succes', to: 'pages#signup_success', as: :signup_success
  get 'signin_success', to: 'pages#signin_success', as: :signin_success
  get 'logout', to: 'sessions#destroy'

  get '/users' => 'user#index', as: 'users'

  get '/users/edit' => 'user#edit', as:'edit'

  put '/users/:id/update' => 'user#update', as: 'update_user'
  put '/users/:id/update_password' => 'user#update_password', as: 'update_password'
  put 'users/:id/update_payment' => 'user#update_payment', as: 'update_payment'
  post '/users/:id' => 'user#update_or_create_address', as: 'update_address'

  get 'auth/github/callback', to: 'sessions#github'
  get 'auth/google_oauth2/callback', to: 'sessions#google'

  post '/logout' => 'sessions#destroy'
end
