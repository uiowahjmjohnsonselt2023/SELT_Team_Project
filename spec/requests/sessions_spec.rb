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

  describe "POST #SSO" do
    context "with valid credentials" do
      it "signs in the user and redirects to signup_success_path" do

        user = FactoryBot.create(:user, name: "Test User", email: "test@gmail.com", password: "password")

        auth_hash = generate_valid_auth_hash(user.email, user.name, user.password)

        get '/auth/github/callback', omniauth_auth: auth_hash

        expect(response).to redirect_to(signup_success_path)
      end
    end

    context "with invalid credentials" do
      it "does not sign in the user, sets flash, and redirects to root_path" do
        # Assuming you have an OAuth hash generator for testing
        user = FactoryBot.create(:user, name: "Test User", email: "test@gmail.com", password: "password")

        auth_hash = generate_invalid_auth_hash(user.email, user.name, user.password)

        get '/auth/github/callback', omniauth_auth: auth_hash

        expect(response).to redirect_to(root_path)
        expect(flash[:warning]).to eq("Please make your email public on Github")
      end
    end
    it "signs in the user and redirects to signup_success_path" do

      auth_hash = generate_valid_auth_hash("James21@gmail.com", "james", "aldskflkasdjfa")

      get '/auth/github/callback', omniauth_auth: auth_hash

      expect(response).to redirect_to(signup_success_path)
    end
  end
end
