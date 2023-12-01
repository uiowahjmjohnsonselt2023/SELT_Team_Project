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

    it 'is invalid with a name too short' do
      product = Product.new(name: 'ab')
      product.valid?
      expect(product.errors[:name]).to include('is too short (minimum is 3 characters)')
    end

    it 'is invalid with a name too long' do
      long_name = 'a' * 51
      product = Product.new(name: long_name)
      product.valid?
      expect(product.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'is invalid without a price' do
      product = Product.new(price: nil)
      product.valid?
      expect(product.errors[:price]).to include("is not a number")
    end

    it 'is invalid with negative discount number' do
      product = Product.new(discount: -1)
      product.valid?
      expect(product.errors[:discount]).to include("must be greater than or equal to 0")
    end

    it 'is invalid with a number greater than 100 for discount' do
      product = Product.new(discount: 110)
      product.valid?
      expect(product.errors[:discount]).to include("must be less than or equal to 100")
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

    it 'has many cart items' do
      association = described_class.reflect_on_association(:cart_items)
      expect(association.macro).to eq :has_many
    end

    it 'has many carts through cart items' do
      association = described_class.reflect_on_association(:carts)
      expect(association.macro).to eq :has_many
    end

    it 'has many product tags' do
      association = described_class.reflect_on_association(:product_tags)
      expect(association.macro).to eq :has_many
    end

    it 'has many tags through product_tags' do
      association = described_class.reflect_on_association(:tags)
      expect(association.macro).to eq :has_many
    end

    it 'has many images' do
      association = described_class.reflect_on_association(:images)
      expect(association.macro).to eq :has_many
    end

    it 'belogngs to category' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'search' do
    before(:each) do
      @user = FactoryBot.create(:user)

      @food = FactoryBot.create(:category, name: 'Food')
      @electronics = FactoryBot.create(:category, name: 'Electronics')
      @everything_else = FactoryBot.create(:category, name: 'Everything else')

      @tag1 = FactoryBot.create(:tag, name: 'Fruit')

      @apple = FactoryBot.create(:product, name: 'Apple', price: 4.99, user: @user)
      FactoryBot.create(:product, name: 'Pineapple', price: 6.99, user: @user)
      FactoryBot.create(:product, name: 'Guava', price: 9.99, user: @user)
      FactoryBot.create(:product, name: 'Mango', price: 2.99, user: @user, category_id: @food.id)
      FactoryBot.create(:product, name: 'Playstation 5', price: 499.99, user: @user, category_id: @electronics.id)

      @apple.tags << @tag1
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

    context 'search by price range' do
      it 'can search by price' do
        other_product = ['Guava', 'Apple', 'Pineapple']
        other_product.each do |product_name|
          expect(Product.search('', min_price: 3, max_price: 10)).to include(Product.find_by(name: product_name))
        end
        expect(Product.search('', min_price: 3, max_price: 10)).not_to include(Product.find_by(name: 'Playstation 5'))
        expect(Product.search('', min_price: 4, max_price: 10)).not_to include(Product.find_by(name: 'Mango'))
      end

      it 'can filter if only entered min price' do
        expect(Product.search('', min_price: 8)).to include(Product.find_by(name: 'Guava'))
        expect(Product.search('', min_price: 8)).to include(Product.find_by(name: 'Playstation 5'))
        other_product = ['Mango', 'Apple', 'Pineapple']
        other_product.each do |product_name|
          expect(Product.search('', min_price: 8)).not_to include(Product.find_by(name: product_name))
        end
      end

      it 'can filter if only entered max price' do
        other_product = ['Mango', 'Apple', 'Pineapple']
        other_product.each do |product_name|
          expect(Product.search('', max_price: 7)).to include(Product.find_by(name: product_name))
        end
        expect(Product.search('', max_price: 7)).not_to include(Product.find_by(name: 'Guava'))
        expect(Product.search('', max_price: 7)).not_to include(Product.find_by(name: 'Playstation 5'))
      end
    end

    context 'category search' do
      it 'can search by categories' do
        expect(Product.search('', category_id: @electronics.id)).to include(Product.find_by(name: 'Playstation 5'))
        other_product = ['Apple', 'Mango', 'Guava', 'Pineapple']
        other_product.each do |product_name|
          expect(Product.search('', category_id: @electronics.id)).not_to include(Product.find_by(name: product_name))
        end
      end

      it 'should have a default categories' do
        products = ['Apple', 'Guava', 'Pineapple']
        products.each do |product_name|
          expect(Product.search('', category_id: @everything_else.id)).to include(Product.find_by(name: product_name))
        end
      end

      it 'handles non-existent category ID gracefully' do
        expect { Product.search('', category_id: -1) }.not_to raise_error
      end
    end

    context 'assign tags and search by tags' do
      it 'assigns tags to a product' do
        product = FactoryBot.create(:product)
        product.tag_list = "Electronics, Sale"
        expect(product.tags.map(&:name)).to include('Electronics', 'Sale')
      end

      it 'correctly assigns and returns tags as a comma-separated string' do
        product = FactoryBot.create(:product)
        product.tag_list = "Tag1, Tag2, Tag3"
        expect(product.tag_list).to eq("Tag1, Tag2, Tag3")
      end

      it 'ignores duplicate tags' do
        product = FactoryBot.create(:product)
        product.tag_list = "Tag1, Tag1, Tag2"
        expect(product.tags.count).to eq(2)
      end

      it 'limits to 3 tags' do
        product = FactoryBot.create(:product)
        product.tag_list = "Tag1, Tag2, Tag3, Tag4"
        expect(product.tags.count).to eq(3)
      end

      it 'returns no products for non-existent tags' do
        FactoryBot.create(:product)
        result = Product.search('', tag_list: 'NonExistentTag')
        expect(result).to be_empty
      end

      it 'returns products with a specific tag' do
        tagged_product = FactoryBot.create(:product)
        untagged_product = FactoryBot.create(:product)
        tag = FactoryBot.create(:tag, name: 'Electronics')
        tagged_product.tags << tag

        result = Product.search('', tag_list: 'Electronics')
        expect(result).to include(tagged_product)
        expect(result).not_to include(untagged_product)
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
