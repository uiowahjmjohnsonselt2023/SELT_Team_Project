Rails.application.routes.draw do
  resources :products, :user, :carts

  resources :cart_items, only: %i[create update destroy]

  resources :signup, only: %i[new create]
  resources :sessions, only: %i[new create]

  root :to => redirect('/products')

  # cart routes
  post '/cart/:product_id', to: 'carts#add', as: 'add_to_cart'
  post 'carts/:id/remove/:product_id' => 'carts#remove'

  # product routes
  get 'products' => 'products#index'
  get 'products/new' => 'products#new'
  post 'products/create' => 'products#create'
  get 'products/:id' => 'products#show', as: :show_product
  post 'products/search' => 'products#search', as: :product_search

  # about page route
  get 'about', to: 'pages#about'

  # User routes
  get 'signup' => 'signup#new'
  get 'signup_succes', to: 'pages#signup_success', as: :signup_success
  get 'logout', to: 'sessions#destroy'

  get '/users' => 'user#index', as: 'users'

  get '/users/edit' => 'user#edit', as:'edit'

  put '/users/:id/update' => 'user#update', as: 'update_user'
  put '/users/:id/update_password' => 'user#update_password', as: 'update_password'
  post '/users/:id' => 'user#update_or_create_address', as: 'update_address'

end
