require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET #new" do
    it "renders the new template" do
      get signup_path # Updated to use signup_path for new user registration
      expect(response).to render_template(:new)
    end

    it "assigns a new user to @user" do
      get signup_path # Updated to use signup_path for new user registration
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  # Test for profile page display when signed in
  describe "GET #show" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        # Manually sign in the user
        post sessions_path, params: { session: { email: @user.email, password: 'password' } }
        # Set the user_id in the session
        session[:user_id] = @user.id
      end

      it "renders the show template" do
        get user_path(@user)
        expect(response).to render_template(:show)
      end

      it "renders edit template" do
        get edit_user_path(@user)
        expect(response).to render_template(:edit)
      end
    end

    context "when user is not signed in" do
      it "redirects to the signup page" do
        get "/users"
        expect(response).to redirect_to(signup_path)
      end
    end

  end

end
