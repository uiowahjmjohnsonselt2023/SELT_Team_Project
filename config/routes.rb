Rails.application.routes.draw do
  root :to => redirect('/product')

  resources :products, :users

  # cart routes
  get 'cart' => 'cart#show'
  post 'cart/add/:id' => 'cart#add', as: :add_to_cart
  post 'cart/remove' => 'cart#remove'
  post 'cart/clear'

  # product routes
  get 'product' => 'product#index'
  get 'product/new' => 'product#new'
  post 'product/create' => 'product#create'
  get 'product/:id' => 'product#show', as: :show_product

  post 'product/search' => 'product#search'
  
end
