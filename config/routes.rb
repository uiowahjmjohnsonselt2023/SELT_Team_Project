Rails.application.routes.draw do
  root :to => redirect('/index')

  resources :products, :user

  get 'index' => 'main#index'

  get 'search/products' => 'product#search', as: 'search_products'

  post 'add_to_cart/:id' => 'main#add_to_cart', as: 'add_to_cart'

  get 'view_cart' => 'main#view_cart', as: 'view_cart'

  #this is the route to go to the users page. It's really hacked together, but it does work right now.

  get '/users' => 'user#index', as: 'users'

  get '/users/edit' => 'user#edit', as:'edit'

  #post '/users/edit' => 'user#edit', as: 'edit'
end
