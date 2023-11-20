require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe CartItem do
    let(:product) { create(:product) }
    let(:cart) { create(:cart) }
  
    it 'validates quantity is present' do
      cart_item = CartItem.new(quantity: nil, product: product, cart: cart)
      expect(cart_item.valid?).to eq false
    end
  
    it 'validates quantity is greater than 0' do
      cart_item = CartItem.new(quantity: 0, product: product, cart: cart)
      expect(cart_item.valid?).to eq false
    end
  
    it 'validates product_id is present' do
      cart_item = CartItem.new(product_id: nil, quantity: 1, cart: cart)
      expect(cart_item.valid?).to eq false
    end
  
    it 'validates cart_id is present' do
      cart_item = CartItem.new(cart_id: nil, quantity: 1, product: product)
      expect(cart_item.valid?).to eq false
    end

  end
  
  describe 'methods ' do
    let(:product) { create(:product) }
    let(:cart) { create(:cart) }
    let(:cart_item) { create(:cart_item, product: product, cart: cart) }

    it 'returns the total price of the cart item' do
      expect(cart_item.total_price).to eq product.price * cart_item.quantity
    end

    it 'returns the total quantity of the cart item' do
      expect(cart_item.total_quantity).to eq cart_item.quantity
    end
  end
end