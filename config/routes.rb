Rails.application.routes.draw do
  root :to => redirect('/products')

  resources :products, :user, :carts
  
  resources :cart_items, only: %i[create update destroy]

  resources :signup, only: %i[new create]
  resources :sessions, only: %i[new create]


  # cart routes
  post 'carts/:id/add/:product_id' => 'carts#add'
  post 'carts/:id/remove/:product_id' => 'carts#remove'

  # product routes
  get 'products' => 'products#index'
  get 'products/new' => 'products#new'
  post 'products/create' => 'products#create'
  get 'products/:id' => 'products#show', as: :show_product
  post 'products/search' => 'products#search', as: :product_search

  # User routes
  get 'signup' => 'signup#new'
  get 'signup_succes', to: 'pages#signup_success', as: :signup_success
  get 'logout', to: 'sessions#destroy'

  get '/users' => 'user#index', as: 'users'

  get '/users/edit' => 'user#edit', as:'edit'


end
