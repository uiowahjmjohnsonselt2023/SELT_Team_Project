require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST #create" do
    context "with valid credentials" do
      it "signs in the user and redirects to signup_success_path" do
        user = FactoryBot.create(:user)
        
        post sessions_path, email: user.email, password: 'password' 
        expect(response).to redirect_to(signup_success_path)
      end
    end

    context "with invalid credentials" do
      it "does not sign in the user, sets flash, and renders the new template" do
        post sessions_path, email: 'invalid@example.com', password: 'invalid' 
        expect(response).to render_template(:new)
        expect(flash[:signin]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryBot.create(:user)
      post sessions_path, email: @user.email, password: 'password'  # sign in the user
    end

    it "signs out the user and redirects to root_path" do
      get logout_path
      expect(response).to redirect_to(root_path)
    end
  end
end
