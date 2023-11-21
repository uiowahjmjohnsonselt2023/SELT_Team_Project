require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "redirects when users are not logged in" do
      get(users_path)
      expect(response).to redirect_to(signup_path)
    end
    #attempted test, does not work - fix later
    it "does not redirect when user is logged in" do
      user = FactoryBot.create(:user)
      get(users_path)
      expect(response).to eq(users_path)
    end

  end
end
