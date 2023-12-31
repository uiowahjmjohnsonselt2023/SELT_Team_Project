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

    it 'is invalid with a password shorter than 6 characters' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

    it 'is invalid with a name longer than 25 characters' do
      user = build(:user, name: 'a' * 26)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too long (maximum is 25 characters)')
    end

    it 'is invalid with an incorrectly formatted email' do
      invalid_emails = ['user@foo,com', 'user_at_foo.org', 'example.user@foo.']
      invalid_emails.each do |invalid_email|
        user = build(:user, email: invalid_email)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    it 'is invalid with a duplicate email, case insensitive' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'Test@Example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'requires a password when creating a new record' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user.valid?).to be false
      expect(user.errors[:password]).to include("can't be blank")  # Adjust the error message based on your validation message
    end

    it 'does not require a password when updating a record' do
      user = create(:user, password: 'password', password_confirmation: 'password')
      user.name = 'Updated Name'
      expect(user.valid?).to be true
    end

    context 'when updating a user' do
      let(:user) { create(:user) }

      it 'is valid when updating name' do
        user.name = 'New Name'
        expect(user).to be_valid
      end

      it 'is valid when updating email with correct format' do
        user.email = 'new_email@example.com'
        expect(user).to be_valid
      end

      it 'is invalid when updating email with incorrect format' do
        user.email = 'invalid_email'
        expect(user).not_to be_valid
      end

      it 'does not require a password when email is updated' do
        user.email = 'new_email@example.com'
        expect(user.valid?).to be true
      end
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

    it 'has many recent_purchases' do
      assc = User.reflect_on_association(:recent_purchases)
      expect(assc.macro).to eq :has_many
    end

    it 'has many addresses' do
      assc = User.reflect_on_association(:addresses)
      expect(assc.macro).to eq :has_many
    end
  end

  # Test that the user can only have 3 addresses
  describe 'address limit validation' do
    it 'does not allow more than 3 addresses' do
      user = create(:user)
      3.times do
        user.addresses.create!(street: '123 Street', city: 'City', state: 'State', zip: '12345', country: 'Country')
      end
      new_address = user.addresses.build(street: '123 Street', city: 'City', state: 'State', zip: '12345', country: 'Country')
      expect(new_address.save).to be false  # The save should not succeed
      expect(new_address.errors[:user]).to include("can only have up to 3 addresses.")
    end
  end
  
  # Tests for destruction of associated objects
  describe 'associations' do
    it 'destroys associated products when user is destroyed' do
      user = create(:user)
      user.products.create(attributes_for(:product))
      expect { user.destroy }.to change(Product, :count).by(-1)
    end

    it 'destroys associated cart when user is destroyed' do
      user = create(:user)
      #cart = user.create_cart
      expect { user.destroy }.to change(Cart, :count).by(-1)
    end
  end
end
