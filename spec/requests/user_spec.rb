require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "redirects when users are not logged in" do
      get(users_path)
      expect(response).to redirect_to(signup_path)
    end

    it "does not redirect when users are logged in" do
      get(users_path)
      expect(response.to redirect_to(:))
    end
  end
end
