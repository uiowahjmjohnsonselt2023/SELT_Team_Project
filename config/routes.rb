Rails.application.routes.draw do
  root :to => redirect('/products')

  resources :products, :users, :carts
  
  resources :cart_items, only: %i[create update destroy]

  resources :signup, only: %i[new create]
  resources :sessions, only: %i[new create]

  # cart routes
  post 'carts/:id/add/:product_id' => 'carts#add'
  # product routes
  get 'products' => 'products#index'
  get 'products/new' => 'products#new'
  post 'products/create' => 'products#create'
  get 'products/:id' => 'products#show', as: :show_product

  post 'product/search' => 'products#search'

  # User routes
  get 'signup' => 'signup#new'
  get 'signup_succes', to: 'pages#signup_success', as: :signup_success
  get 'logout', to: 'sessions#destroy'
end
