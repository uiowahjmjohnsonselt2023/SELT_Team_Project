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

  describe 'search' do
    before(:all) do
      @user = FactoryBot.create(:user)
      FactoryBot.create(:product, name: 'Apple', user: @user)
      FactoryBot.create(:product, name: 'Pineapple', user: @user)
      FactoryBot.create(:product, name: 'Guava', user: @user)
      FactoryBot.create(:product, name: 'Mango', user: @user)
    end

    it 'returns products using lowercase for search term' do
        expect(Product.search('apple')).to include(Product.find_by(name: 'Apple'))
    end

    it 'returns related products' do
        expect(Product.search('apple')).to include(Product.find_by(name: 'Apple'))
        expect(Product.search('apple')).to include(Product.find_by(name: 'Pineapple'))
        expect(Product.search('apple')).to_not include(Product.find_by(name: 'Guava'))
    end

    it 'returns the similar product when there is typo' do
        expect(Product.search('appels')).to include(Product.find_by(name: 'Apple'))
    end

    it 'returns all products when search term empty' do
        expect(Product.search('')).to match_array(Product.all)
    end
  end
end
