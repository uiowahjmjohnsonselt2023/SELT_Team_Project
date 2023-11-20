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
    before(:all) do
      @products = FactoryBot.create_list(:product, 10)
    end
    
    before(:each) do
      @user = FactoryBot.create(:user)
      @cart = @user.cart
    end

    it 'adds a product to the cart' do
      # add 5 products to the cart
      @products[0..4].each do |product|
        @cart.add_product(product.id, 1)
      end

      expect(@cart.products.count).to eq 5  
    end 

    it 'increments the quantity of a product in the cart if it already exists' do
      product = @products[0]
      @cart.add_product(product.id)
      @cart.add_product(product.id)
      
      expect(@cart.products.count).to eq 1
      expect(@cart.cart_items.first.quantity).to eq 2
    end

    it 'returns the total price of the cart' do
      total_price = 0
      @products[0..4].each do |product|
        @cart.add_product(product.id)
        total_price += product.price
      end

      expect(@cart.total_price).to eq total_price
    end

    it 'returns the total quantity of the cart' do
      total_quantity = 0
      @products[0..4].each do |product|
        @cart.add_product(product.id)
        total_quantity += 1
      end

      expect(@cart.total_quantity).to eq total_quantity
    end

  end

end
