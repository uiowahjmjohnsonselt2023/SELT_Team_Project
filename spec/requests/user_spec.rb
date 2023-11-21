require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "redirects when users are not logged in" do
      get(users_path)
      expect(response).to redirect_to(signup_path)
    end

  end
  describe "Get /show" do
    it "assigns the requested product to @product" do
      user = FactoryBot.create(:user)
      get show_user_path(user)
      expect(assigns(:user)).to eq(user)
    end
  end
end
