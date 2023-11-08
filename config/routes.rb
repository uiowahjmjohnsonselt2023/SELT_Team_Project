Rails.application.routes.draw do
  root :to => redirect('/index')

  resources :products, :users

  get 'index' => 'main#index'

  get 'search/products' => 'product#search', as: 'search_products'

  post 'add_to_cart/:id' => 'main#add_to_cart', as: 'add_to_cart'

  get 'view_cart' => 'main#view_cart', as: 'view_cart'
end
