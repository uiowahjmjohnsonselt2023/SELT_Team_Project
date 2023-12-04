require 'rails_helper'

# Database Cleaner Configuration
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

# Test cases for UserController
RSpec.describe UserController, type: :controller do
  describe 'PUT #update_password' do
    let(:user) { create(:user) }
    let(:new_password) { 'newpassword123' }

    it 'updates the password' do
      put :update_password, params: { id: user.id, user: { password: new_password, password_confirmation: new_password } }
      user.reload
      expect(user.authenticate(new_password)).to be_truthy
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user and their details to @user' do
      user = create(:user)
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #edit' do
    context 'when the user is correct' do
      it 'renders the edit template' do
        user = create(:user)
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end
    end
  end
end
