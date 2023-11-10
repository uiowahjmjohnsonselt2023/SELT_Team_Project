Rails.application.routes.draw do
  root :to => redirect('/products')

  resources :products, :users

  # cart routes
  get 'cart' => 'cart#show'
  post 'cart/add/:id' => 'cart#add', as: :add_to_cart
  post 'cart/remove' => 'cart#remove'
  post 'cart/clear'

  # product routes
  get 'products' => 'products#index'
  get 'products/new' => 'products#new'
  post 'products/create' => 'products#create'
  get 'products/:id' => 'products#show', as: :show_product

  post 'product/search' => 'products#search'

  # User routes
  resources :signup, only: %i[new create]
  resources :sessions, only: %i[new create]
  get 'signup' => 'signup#new'
  get 'signup_succes', to: 'pages#signup_success', as: :signup_success
  get 'logout', to: 'sessions#destroy'
  
end
