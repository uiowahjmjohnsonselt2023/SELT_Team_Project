require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /index" do 
    it "renders the products page" do
      get "/products"
      expect(response).to render_template(:index)
    end

    it "assigns all products to @products" do
      get products_path
      expect(assigns(:products)).to eq(Product.all)
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

      get show_product_path(product)
      expect(response).to render_template("show")
    end
    context "when the product does not exist" do
      it "flashes a warning" do
        get show_product_path(id: -1)
        expect(flash[:warning]).to eq("Product not found #{-1}")
      end
      it "redirects to root path" do
        get show_product_path(id: -1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the product exists" do
      it "does not flash a warning" do
        product = FactoryBot.create(:product)
        get show_product_path(product)
        expect(flash[:warning]).to be_nil
      end
      it "does not redirect to root path" do
        product = FactoryBot.create(:product)
        get show_product_path(product)
        expect(response).not_to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    context "when the user does not own the product" do
      it "redirects to root path" do
        product = FactoryBot.create(:product)
        get edit_product_path(product)
        expect(response).to redirect_to(root_path)
      end

      it "flashes a warning" do
        product = FactoryBot.create(:product)
        get edit_product_path(product)
        expect(flash[:warning]).to eq("You need to sign in before accessing this page.")
      end
    end

    context "when the user owns the product" do
      before(:all) do
        # Sign in a user
        @user = FactoryBot.create(:user)
        @user.cart = FactoryBot.create(:cart)
        post sessions_path, email: @user.email, password: 'password' 

        # Create a product for that user
        @product = FactoryBot.create(:product)
        @user.products << @product
      end

      it "renders the edit template" do
        get edit_product_path(@product)
        expect(response).to render_template("edit")
      end

      it "assigns the correct product to @product" do
        get edit_product_path(@product)
        expect(assigns(:product)).to eq(@product)
      end
    end

    context "when the product does not exist" do
      before(:all) do 
        @user = FactoryBot.create(:user)
        @user.cart = FactoryBot.create(:cart)

        post sessions_path, email: @user.email, password: 'password'
      end
      it "flashes a warning" do
        get edit_product_path(id: -1)
        expect(flash[:warning]).to eq("Product not found")
      end
      it "redirects to root path" do
        get edit_product_path(id: -1)
        expect(response).to redirect_to(user_path(@user))
      end
    end
  end
  # describe "POST #create" do
  #   context "with valid parameters" do
  #     it "creates a new product" do
  #       product = FactoryBot.create(:product)
  #       expect {
  #         post products_path, params: { product: { name: "Sample Product", description: "A description for the product", price: 20, quantity: 10, user_id: 1 } }
  #       }.to change(Product, :count).by(1)
  #     end

  #     it "redirects to the created product's show page" do
  #       post products_path, params: { product: FactoryBot.attributes_for(:product) }
  #       expect(response).to redirect_to(Product.last)
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "does not create a new product" do
  #       expect {
  #         post products_path, params: { product: FactoryBot.attributes_for(:product, name: nil) }
  #       }.not_to change(Product, :count)
  #     end

  #     it "renders the new template" do
  #       post products_path, params: { product: FactoryBot.attributes_for(:product, name: nil) }
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end
end

