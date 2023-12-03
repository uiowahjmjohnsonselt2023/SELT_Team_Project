require 'rails_helper'

RSpec.describe User, type: :model do
  # Test for valid factory
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  # Test validations
  describe 'validations' do
    it 'is invalid without a name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid with a duplicate email' do
      user1 = create(:user, email: 'test@example.com')
      user2 = build(:user, email: 'test@example.com')
      expect(user2).not_to be_valid
    end

    it 'is invalid with an invalid email format' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
    end

    it 'requires a password when creating a new record' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'does not require a password when updating a record' do
      user = create(:user)
      user.name = 'Updated Name'
      expect(user).to be_valid
    end
  end

  # Test associations
  describe 'associations' do
    it 'has many products' do
      assc = User.reflect_on_association(:products)
      expect(assc.macro).to eq :has_many
    end

    it 'has one cart' do
      assc = User.reflect_on_association(:cart)
      expect(assc.macro).to eq :has_one
    end
  end

  # Add more tests for your custom methods here
end

