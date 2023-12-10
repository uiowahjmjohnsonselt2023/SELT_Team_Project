require 'rails_helper'

RSpec.describe "Carts", type: :request do
  describe 'GET #show' do
    context "when user is not logged in" do
      it "redirects to root path" do
        get cart_path(id: 1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is logged in" do
      before(:all) do
        @user = FactoryBot.create(:user)
        post sessions_path, email: @user.email, password: 'password'
      end

      it 'renders the show template' do
        get cart_path(@user.id)
        expect(response).to render_template(:show)
      end

      context 'when user has items in cart' do
        before(:all) do
          @product = FactoryBot.create(:product)
          post add_to_cart_path(@product.id)
        end

        it 'renders the show template' do
          get cart_path(@user.id)
          expect(response).to render_template(:show)
        end
      end

      context 'when user has no items in cart' do
        it 'renders the show template' do
          get cart_path(@user.id)
          expect(response).to render_template(:show)
        end
      end
    end 
  end

  describe 'POST #add' do
    context "when user is not logged in" do
      it "redirects to root path" do
        post add_to_cart_path(1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is logged in" do
      before(:all) do
        @user = FactoryBot.create(:user)
        post sessions_path, email: @user.email, password: 'password'
      end

      context "when product is valid" do
        before(:all) do
          @product = FactoryBot.create(:product)
        end

        it "adds the product to the cart" do
          post add_to_cart_path(@product.id)
          expect(response).to redirect_to(root_path)
        end
      end

      context "when product is invalid" do
        before(:all) do
          @product = FactoryBot.create(:product, quantity: 0)
        end

        it "does not add the product to the cart" do
          post add_to_cart_path(@product.id)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'POST #destroy' do
   
  end
end