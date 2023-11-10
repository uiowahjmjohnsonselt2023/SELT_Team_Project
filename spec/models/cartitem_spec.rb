require 'rails_helper'

RSpec.describe Cartitem, type: :model do
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
end
