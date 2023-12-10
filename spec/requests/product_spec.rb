require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /index" do 
    it "renders the products page" do
      get "/products"
      expect(response).to render_template(:index)
    end

    it "assigns all products to @products" do
      get products_path
      expect(assigns(:products)).to eq(Product.where(archived: false))
    end
  end

  describe "GET /new" do
    context "when user is not logged in" do
      it "redirects to root path" do
        get "/products/new", nil, { "user_id": nil }
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is logged in" do
      before(:all) do
        @user = FactoryBot.create(:user)
        post sessions_path, email: @user.email, password: 'password'
      end

      it "renders the new product page" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        allow_any_instance_of(ApplicationController).to receive(:ensure_signed_in!).and_return(true)
        
        get "/products/new", nil, { "user_id": @user.id }

        expect(response).to render_template(:new)
      end

      it "assigns a new product to @product" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        allow_any_instance_of(ApplicationController).to receive(:ensure_signed_in!).and_return(true)

        get "/products/new", nil, { "user_id": @user.id}
        expect(assigns(:product)).to be_a_new(Product)
      end
    end
  end

  describe "GET #show" do
    context "when the product exists" do
      it "renders the show template" do
        product = FactoryBot.create(:product)
        get product_path(product)
        expect(response).to render_template("show")
      end
      it "renders all the images for the product" do
        product = FactoryBot.create(:product)
        get product_path(product)
        expect(assigns(:images)).to eq(product.images)
      end
    end
    context "when the product does not exist" do
      it "flashes a warning" do
        get product_path(id: -1)
        expect(flash[:warning]).to eq("Product not found #{-1}")
      end
      it "redirects to root path" do
        get product_path(id: -1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the product exists" do
      it "does not flash a warning" do
        product = FactoryBot.create(:product)
        get product_path(product)
        expect(flash[:warning]).to be_nil
      end
      it "does not redirect to root path" do
        product = FactoryBot.create(:product)
        get product_path(product)
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
    
  describe "POST #create" do
    context "when the user is not logged in" do
      it "redirects to root path" do
        post products_path, params: { product: FactoryBot.attributes_for(:product) }
        expect(response).to redirect_to(root_path)
      end

      it "flashes a warning" do
        post products_path, params: { product: FactoryBot.attributes_for(:product) }
        expect(flash[:warning]).to eq("You need to sign in before accessing this page.")
      end
    end

    context "when the user is logged in" do
      before(:all) do
        @user = FactoryBot.create(:user)
        post sessions_path, email: @user.email, password: 'password'
      end

      context "with valid parameters" do
        before(:all) do 
          @image = fixture_file_upload('files/test_image.jpg')
          @valid_params = { name: "Sample Product", description: "A description for the product", price: 20, quantity: 10, user_id: @user.id, images: [@image]}
        end

        it "creates a new product" do
          expect {
            post products_path, { product: @valid_params}
          }.to change(Product, :count).by(1)
        end

        it "redirects to the users profile page" do
          post products_path, { product: @valid_params }
          expect(response).to redirect_to(@user)
        end
      end

      context "with invalid parameters" do
        it "does not create a new product" do
          expect {
            post products_path, { product: FactoryBot.attributes_for(:product, name: nil) }
          }.not_to change(Product, :count)
        end
        it "does not create a new product with valid product attributes but invalid image attributes" do
          @image = fixture_file_upload('files/incorrect_img.dat')
          @invalid_params = { name: nil, description: "A description for the product", price: 20, quantity: 10, user_id: @user.id, images: [@image]}
          expect {
            post products_path, {product: @invalid_params}
          }.not_to change(Product, :count)
        end
        it "renders the new template" do
          post products_path, { product: FactoryBot.attributes_for(:product, name: nil) }
          expect(response).to redirect_to(new_product_path)
        end
      end
    end
  end 

  describe "PUT #update" do
    context "when the user is not logged in" do
      it "redirects to root path" do
        product = FactoryBot.create(:product)
        put product_path(product), { product: FactoryBot.attributes_for(:product) }
        expect(response).to redirect_to(root_path)
      end

      it "flashes a warning" do
        product = FactoryBot.create(:product)
        put product_path(product), { product: FactoryBot.attributes_for(:product) }
        expect(flash[:warning]).to eq("You need to sign in before accessing this page.")
      end
    end

    context "when the user is logged in" do
      before(:all) do
        @user = FactoryBot.create(:user)
        post sessions_path, email: @user.email, password: 'password'
      end

      context "with valid parameters" do
        it "updates the product" do
          product = FactoryBot.create(:product, name: "Sample Product")
          @user.products << product
          put product_path(product), { product: { name: "Updated Product" } }
          product.reload
          expect(product.name).to eq("Updated Product")
        end

        it "redirects to the product\'s show page" do
          product = FactoryBot.create(:product, name: "Sample Product")
          @user.products << product
          put product_path(product), { product: { name: "Updated Product" } }
          expect(response).to redirect_to(user_path(@user))
        end
      end

      context "with invalid parameters" do
        it "does not update the product" do
          product = FactoryBot.create(:product, name: "Sample Product")
          @user.products << product

          put product_path(product), { product: { name: nil } }
          product.reload
          expect(product.name).to eq("Sample Product")
        end

        it "renders the edit template" do
          product = FactoryBot.create(:product, name: "Sample Product")
          @user.products << product

          put product_path(product), { product: { name: nil } }
          expect(response).to redirect_to(edit_product_path(product))
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the user is not logged in" do
      it "redirects to root path" do
        product = FactoryBot.create(:product)
        delete product_path(product)

        expect(response).to redirect_to(root_path)
      end

      it "flashes a warning" do
        product = FactoryBot.create(:product)
        delete product_path(product)

        expect(flash[:warning]).to eq("You need to sign in before accessing this page.")
      end
    end

    context "when the user is logged in" do
      before(:all) do
        @user = FactoryBot.create(:user)
        post sessions_path, email: @user.email, password: 'password'
      end

      context "when the user owns the product" do
        before(:each) do 
          @product = FactoryBot.create(:product)
          @user.products << @product
        end 
        
        it "deletes the product" do
          expect {
            delete product_path(@product)
          }.to change(Product.where(archived: false), :count).by(-1)
        end

        it "redirects to the user\'s show page" do
          delete product_path(@product)
          expect(response).to redirect_to(user_path(@user))
        end
      end

      context "when the user does not own the product" do
        before(:each) do
          @product = FactoryBot.create(:product)
        end

        it "does not delete the product" do
          expect {
            delete product_path(@product)
          }.not_to change(Product, :count)
        end

        it "redirects to the user\'s path" do
          delete product_path(@product)
          expect(response).to redirect_to(user_path(@user))
        end
      end
    end
  end
end