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
      FactoryBot.create(:user)
      get show_product_path(product)
      expect(response).to render_template("show")
    end

    it "assigns the requested product to @product" do
      product = FactoryBot.create(:product)
      FactoryBot.create(:user)
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
  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new product" do
        product = FactoryBot.create(:product)
        expect {
          post products_path, product: {name: "Sample Product", description: "A description for the product", price: 20, quantity: 10, user_id: 1}
        }.to change(Product, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new product" do
        expect {
          post products_path, product: FactoryBot.attributes_for(:product, name: nil) 
        }.not_to change(Product, :count)
      end

      it "renders the new template" do
        post products_path, product: FactoryBot.attributes_for(:product, name: nil)
        expect(response).to redirect_to(new_product_path)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the product" do
      product = FactoryBot.create(:product)# Ensure the product is created before the test
      puts product.inspect
      expect {
        delete product_path(product.id)
      }.to change(Product, :count).by(-1)

      expect(flash[:notice]).to eq("Product deleted")
      expect(response).to redirect_to(root_path)
    end
  end
  describe "GET #search" do
  it "returns products matching the search term" do
    product = FactoryBot.create(:product, name: 'Product Name')

    post product_search_path, search: 'Product Name'
    expect(assigns(:match)).to include(product)
    expect(response).to render_template("search")
  end

  it "returns all products when no match is found" do
    post product_search_path, search: 'Nonexistent Product'

    expect(assigns(:match)).to match_array(Product.all)
    expect(flash.now[:notice]).to eq("No products found.")
    expect(response).to render_template("search")
  end
end
end

