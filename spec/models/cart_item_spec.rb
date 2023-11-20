require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "validations" do
    before(:all) do
      @user = FactoryBot.create(:user)
      @cart = @user.cart
      @product = FactoryBot.create(:product)
    end

    it 'quantity is present' do
      cart_item = CartItem.new(quantity: nil, product: @product, cart: @cart)
      expect(cart_item.valid?).to eq false
    end
  
    it 'quantity is greater than 0' do
      cart_item = CartItem.new(quantity: 0, product: @product, cart: @cart)
      expect(cart_item.valid?).to eq false
    end
  
    it 'product_id is present' do
      cart_item = CartItem.new(product_id: nil, quantity: 1, cart: @cart)
      expect(cart_item.valid?).to eq false
    end
  
    it 'cart_id is present' do
      cart_item = CartItem.new(cart_id: nil, quantity: 1, product: @product)
      expect(cart_item.valid?).to eq false
    end

  end
  
  describe 'methods ' do
    before(:all) do
      @user = FactoryBot.create(:user)
      @cart = @user.cart
      @product = FactoryBot.create(:product)
      @cart_item = CartItem.new(product: @product, cart: @cart, quantity: 1)
    end

    it 'returns the total price of the cart item' do
      expect(@cart_item.total_price).to eq @product.price * @cart_item.quantity
    end

    it 'returns the total quantity of the cart item' do
      expect(@cart_item.total_quantity).to eq @cart_item.quantity
    end
  end
end