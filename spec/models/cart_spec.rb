require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it 'has many cart_items' do
      association = described_class.reflect_on_association(:cart_items)
      expect(association.macro).to eq :has_many
    end

    it 'has many products' do
      association = described_class.reflect_on_association(:products)
      expect(association.macro).to eq :has_many
    end

    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'instance methods' do
    it 'add_product' do
      cart = Cart.create
      product = Product.find_by(id: 1)
      cart.add_product(product)
      expect(cart.total_quantity).to eq 1
    end

    it 'determines the total price of all items in cart' do
      cart = Cart.create
      product = Product.find_by(id: 1)
      cart.add_product(product)
      allow(:product).to receive(:price).and_return(1.99)
      expect(cart.total_price).to eq 1.99
    end
  end

end
