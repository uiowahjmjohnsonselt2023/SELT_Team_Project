Rails.application.routes.draw do
  root :to => redirect('/index')

  resources :products, :user

  get 'index' => 'main#index'

  get 'search/products' => 'product#search', as: 'search_products'

  post 'add_to_cart/:id' => 'main#add_to_cart', as: 'add_to_cart'

  get 'view_cart' => 'main#view_cart', as: 'view_cart'

  # a test route to see if I can get the users page to flash a message
  # This is just for testing purposes. This route should be commented out or removed before pushing to main


  # post 'users' => 'user#flash_test', as: 'flash_test'

  post 'users' => 'user#flash_test', as: 'users'
end
