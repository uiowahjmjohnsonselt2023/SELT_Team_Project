Rails.application.routes.draw do
  root :to => redirect('/index')

  get 'index' => 'main#index'

  get 'search/products' => 'product#index', as: 'search_products'
end
