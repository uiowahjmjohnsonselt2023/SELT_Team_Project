require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with name, email and password' do
      user = User.new(
        name: 'testName',
        email: 'testEmail@email.com',
        password: "testPass"
      )
      expect(user).to be_valid
    end

  end
end
