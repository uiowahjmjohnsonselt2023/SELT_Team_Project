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
end
