require 'rails_helper'

RSpec.describe "Users", type: :request do

  # Helper method for signing in users
  def sign_in_user(user)
    post sessions_path, params: { session: { email: user.email, password: 'password' } }
    session[:user_id] = user.id
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:ensure_signed_in!).and_return(true)
  end

  describe "GET #admin" do
    context "when user is signed in and is an admin" do
      before do
        @user = FactoryBot.create(:user, :admin)
        sign_in_user(@user)
      end

      #test that an admin can view the page
      it "they can view the page" do
        get admin_path(@user)
        response.status.should be(200)
      end
    end

    context "when user is not an admin" do
      before do
        @user = FactoryBot.create(:user)
        sign_in_user@user
      end

      it "redirect to root" do
        get admin_path(@user)
        expect(response).to redirect_to(root_path)
      end
    end
  end

end