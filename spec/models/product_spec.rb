require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with a name, and description' do
      product = Product.new(
        name: 'Test Product',
        price: 10.99,
        quantity: 1,
        description: 'This is a test product'
      )
      expect(product).to be_valid
    end

    it 'is invalid without a name' do
      product = Product.new(name: nil)
      product.valid?
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      product = Product.new(price: nil)
      product.valid?
      expect(product.errors[:price]).to include("is not a number")
    end
  end

  describe 'associations' do
    it 'has many reviews' do
      association = described_class.reflect_on_association(:reviews)
      expect(association.macro).to eq :has_many
    end

    it 'belongs to a user' do 
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  # describe 'methods' do
  #   context 'search method' do
  #     it 'returns products with similar names to the search term' do
  #       product = Product.create(name: 'Test Product', price: 10.99, description: 'This is a test product')
  #       expect(Product.search('Test')).to include(product)
  #     end
  #   end
  # end
end
