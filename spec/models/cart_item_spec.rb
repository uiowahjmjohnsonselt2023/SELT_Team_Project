require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it 'belongs to a product' do
      association = described_class.reflect_on_association(:product)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a cart' do
      association = described_class.reflect_on_association(:cart)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    it 'validates quantity is present' do
      cartitem = CartItem.new(quantity: nil)
      expect(cartitem.valid?).to eq false
    end

    it 'validates quantity is greater than 0' do
      cartitem = CartItem.new(quantity: 0)
      expect(cartitem.valid?).to eq false
    end

    it 'validates product_id is present' do
      cartitem = CartItem.new(product_id: nil)
      expect(cartitem.valid?).to eq false
    end

    it 'validates cart_id is present' do
      cartitem = CartItem.new(cart_id: nil)
      expect(cartitem.valid?).to eq false
    end
    
    it 'is valid with valid attributes' do
      cartitem = CartItem.new(quantity: 1, product_id: 1, cart_id: 1)
      expect(cartitem.valid?).to eq true
    end
  end
end
