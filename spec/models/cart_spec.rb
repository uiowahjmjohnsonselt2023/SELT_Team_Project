require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "adding products to the cart" do
    it "should add a product to the cart" do
      cart = Cart.new
      product = Product.new(name: "Test Product", price: 10.00)
      cart.add_product(product)
      expect(cart.products).to include(product)
    end
  end

  describe "removing products from the cart" do
    it "should remove a product from the cart" do
      cart = Cart.new
      product = Product.new(name: "Test Product", price: 10.00)
      cart.add_product(product)
      cart.remove_product(product)
      expect(cart.products).not_to include(product)
    end
  end

  describe "determining the total price inside the cart" do
    it "should calculate the total price of all products in the cart" do
      cart = Cart.new
      product1 = Product.new(name: "Test Product 1", price: 10.00)
      product2 = Product.new(name: "Test Product 2", price: 20.00)
      cart.add_product(product1)
      cart.add_product(product2)
      expect(cart.total_price).to eq(30.00)
    end
  end
  
  describe "associations" do 
    it "has many products" do 
      association = described_class.reflect_on_association(:products)
      expect(association.macro).to eq :has_many
    end
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

end
  
end
