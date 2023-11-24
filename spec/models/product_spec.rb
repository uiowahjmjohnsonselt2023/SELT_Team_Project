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
    before(:each) do
      @user = FactoryBot.create(:user)

      @food = FactoryBot.create(:category, name: 'Food')
      @electronics = FactoryBot.create(:category, name: 'Electronics')
      @everything_else = FactoryBot.create(:category, name: 'Everything else')

      FactoryBot.create(:product, name: 'Apple', price: 4.99, user: @user)
      FactoryBot.create(:product, name: 'Pineapple', price: 6.99, user: @user)
      FactoryBot.create(:product, name: 'Guava', price: 9.99, user: @user)
      FactoryBot.create(:product, name: 'Mango', price: 2.99, user: @user, category_id: @food.id)
      FactoryBot.create(:product, name: 'Playstation 5', price: 499.99, user: @user, category_id: @electronics.id)
    end

    after(:each) do
      DatabaseCleaner.clean_with(:truncation)
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

    it 'can search by price' do
      expect(Product.search('', min_price: 3, max_price: 10)).to include(Product.find_by(name: 'Apple'))
      expect(Product.search('', min_price: 3, max_price: 10)).to include(Product.find_by(name: 'Pineapple'))
      expect(Product.search('', min_price: 3, max_price: 10)).to include(Product.find_by(name: 'Guava'))
      expect(Product.search('', min_price: 3, max_price: 10)).not_to include(Product.find_by(name: 'Playstation 5'))
      expect(Product.search('', min_price: 4, max_price: 10)).not_to include(Product.find_by(name: 'Mango'))
    end

    it 'can filter if only entered min price' do
      expect(Product.search('', min_price: 8)).to include(Product.find_by(name: 'Guava'))
      expect(Product.search('', min_price: 8)).to include(Product.find_by(name: 'Playstation 5'))
      expect(Product.search('', min_price: 8)).not_to include(Product.find_by(name: 'Mango'))
      expect(Product.search('', min_price: 8)).not_to include(Product.find_by(name: 'Apple'))
      expect(Product.search('', min_price: 8)).not_to include(Product.find_by(name: 'Pineapple'))
    end

    it 'can filter if only entered max price' do
      expect(Product.search('', max_price: 7)).to include(Product.find_by(name: 'Mango'))
      expect(Product.search('', max_price: 7)).to include(Product.find_by(name: 'Apple'))
      expect(Product.search('', max_price: 7)).to include(Product.find_by(name: 'Pineapple'))
      expect(Product.search('', max_price: 7)).not_to include(Product.find_by(name: 'Guava'))
      expect(Product.search('', max_price: 7)).not_to include(Product.find_by(name: 'Playstation 5'))
    end

    it 'can search by categories' do
      expect(Product.search('', category_id: @electronics.id)).to include(Product.find_by(name: 'Playstation 5'))
      other_product = ['Apple', 'Mango', 'Guava', 'Pineapple']
      other_product.each do |product_name|
        expect(Product.search('', category_id: @electronics.id)).not_to include(Product.find_by(name: product_name))
      end
    end

    # it 'should have a default categories' do
    #   products = ['Apple', 'Guava', 'Pineapple']
    #   products.each do |product_name|
    #     expect(Product.search('', category_id: @everything_else.id)).to include(Product.find_by(name: product_name))
    #   end
    # end
  end
end
