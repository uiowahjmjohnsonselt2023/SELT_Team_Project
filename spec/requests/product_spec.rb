require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do 
    it "renders the products page" do
      get "/products"
      expect(response).to render_template(:index)
    end
  end
  describe 'GET /new' do
    it 'renders the new product page' do
      get '/products/new'
      expect(response).to render_template(:new)
    end
  end
  describe 'POST /create' do
    it 'creates a new valid product' do
      fake_product = double('product')
      allow(fake_product).to receive(:save).and_return(true)
      allow(fake_product).to receive(:id).and_return(1)
      allow(Product).to receive(:new).and_return(fake_product)
      allow(response).to receive(:redirect_to).with(show_product_path(fake_product.id))
      post '/products/create', params: { :product => fake_product }
      expect(response).to redirect_to(show_product_path(fake_product.id))
    end
  end
end
