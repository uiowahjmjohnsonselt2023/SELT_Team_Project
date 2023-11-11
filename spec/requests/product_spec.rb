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
  # describe 'POST /create' do
  #   it 'creates a new valid product' do
  #     fake_product = double('product')
  #     allow(fake_product).to receive(:save).and_return(true)
  #     allow(fake_product).to receive(:id).and_return(1)
  #     allow(Product).to receive(:new).and_return(fake_product)
  #     allow(response).to receive(:redirect_to).with(show_product_path(fake_product.id))
  #     post '/products/create', params: { :product => fake_product }
  #     expect(response).to redirect_to(show_product_path(fake_product.id))
  #   end
  # end
  it "should get index" do
    get products_path
    expect(response).to have_http_status(200)
  end
  describe "GET #index" do
    it "renders the index template" do
      get products_path
      expect(response).to render_template("index")
    end

    it "assigns all products to @products" do
      product = FactoryBot.create(:product)
      get products_path
      expect(assigns(:products)).to eq([product])
    end
  end
  describe "GET #show" do
    it "renders the show template" do
      product = FactoryBot.create(:product)
      user = FactoryBot.create(:user)
      get show_product_path(product)
      expect(response).to render_template("show")
    end

    it "assigns the requested product to @product" do
      product = FactoryBot.create(:product)
      user = FactoryBot.create(:user)
      get show_product_path(product)
      expect(assigns(:product)).to eq(product)
    end
  end
  describe "GET #new" do
    it "renders the new template" do
      get new_product_path
      expect(response).to render_template("new")
    end

    it "assigns a new product to @product" do
      get new_product_path
      expect(assigns(:product)).to be_a_new(Product)
    end
  end
end

