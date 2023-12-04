require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe 'PUT /users/:id/update_password' do
    let(:user) { create(:user) }
    let(:new_password) { 'newpassword123' }

    it 'updates the password' do
      put update_password_path(user), params: { user: { password: new_password, password_confirmation: new_password } }
      user.reload
      expect(user.authenticate(new_password)).to be_truthy
    end
  end

  describe 'GET /users/:id' do
    it 'assigns the requested user and their details' do
      user = create(:user)
      get user_path(user)
      expect(response).to have_http_status(:success)
      # Additional checks on the response body can be added here
    end
  end

  describe 'GET /users/:id/edit' do
    context 'when the user is correct' do
      it 'renders the edit template' do
        user = create(:user)
        get edit_path
        expect(response).to have_http_status(:success)
        # Additional checks on the response body can be added here
      end
    end
  end

end
