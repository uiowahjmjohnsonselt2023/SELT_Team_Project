require 'rails_helper'

RSpec.describe "Users", type: :request do

  # Helper method for signing in users
  def sign_in_user(user)
    post sessions_path, params: { session: { email: user.email, password: 'password'} }
    session[:user_id] = user.id
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:ensure_signed_in!).and_return(true)
  end

  # Tests for GET #show
  describe "GET #show" do
    # Context when user is signed in
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      # Test for rendering the user profile page
      it "renders the show template" do
        get user_path(@user)
        expect(response).to render_template(:show)
      end
    end

    # Context when user is not signed in
    context "when user is not signed in" do
      # Test for redirecting to signup page if not signed in
      it "redirects to the signup page" do
        get "/users"
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  # Tests for GET #index
  describe "GET #index" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end
    end
  end

  # Tests for GET #edit
  describe "GET #edit" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      # Test for rendering the edit template
      it "renders the edit template" do
        get edit_user_path(@user)
        expect(response).to render_template(:edit)
      end
    end
  end

  # Tests for PUT #update
  describe "PUT #update" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      # Test for successful user update
      it "updates the user and redirects to show template" do
        updated_params = { user: { name: "New Name", email: @user.email, phone_number: @user.phone_number } }
        put update_user_path(@user), updated_params
        @user.reload
        expect(@user.name).to eq("New Name")
        expect(response).to redirect_to(edit_user_path(@user))
      end

      context "with invalid attributes" do
        # Test for handling invalid update attributes
        it "does not change @user's attributes and re-renders the edit template" do
          put user_path(@user), params: { user: { name: nil } }
          @user.reload
          expect(@user.name).not_to eq(nil)
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end
    end
  end

  # Tests for PUT #update_password
  describe "PUT #update_password" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      context "with valid password parameters" do
        # Test for successful password update
        it "updates the user's password and redirects to the edit user path" do
          updated_password =  {user: { password: 'newpassword', password_confirmation: 'newpassword' } }
          put update_password_path(@user), updated_password
          expect(flash[:notice]).to eq("password updated successfully.")
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end

      context "with invalid password parameters" do
        # Test for handling invalid password update
        it "does not update the user's password and redirects to the edit user path" do
          bad_password =  {user: { password: 'newpassword', password_confirmation: 'mismatch' } }
          put update_password_path(@user), bad_password
          expect(flash[:alert]).to eq("password could not be updated successfully.")
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end
    end
  end

  # Tests for POST #update_or_create_address
  describe "POST #update_or_create_address" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      context "when creating a new address" do
        # Test for creating a new address
        it "creates a new address for the user and redirects to the edit user path" do
          new_address = { street: '123 Test St', city: 'Testville', state: 'TS', zip: '12345', country: 'Testland' }
          post update_address_path(@user), new_address
          expect(@user.addresses.count).to eq(1)
          expect(response).to redirect_to(edit_user_path(@user))
          expect(flash[:notice]).to eq("Address updated/created successfully.")
        end
      end

      context "with invalid address parameters" do
        # Test for handling invalid address parameters
        it "does not create or update the address and redirects to the edit user path" do
          post update_address_path(@user), params: { street: '' } # Intentionally missing other params
          expect(response).to redirect_to(edit_user_path(@user))
          expect(flash[:alert]).to eq("Error updating/creating address.")
        end
      end
    end
  end

  # Tests for before_action :ensure_correct_user
  describe "before_action :ensure_correct_user" do
    context "when a wrong user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        @other_user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      # Test for unauthorized user access
      it "redirects the user to the root path with a flash warning" do
        get edit_user_path(@other_user)
        expect(response).to redirect_to(root_path)
        expect(flash[:warning]).to eq("You do not have permission to edit this user. Please login to the correct account.")
      end
    end
  end

  # Tests for PUT #update_picture
  describe "PUT #update_picture" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user, login_type: 'standard')
        sign_in_user(@user)
      end

      context "with valid image file" do
        it "updates the user's profile picture" do
          # Mock an image upload action here
          @image = fixture_file_upload('files/test_image.jpg')
          updated_image = {user: { image: @image }}
          put update_picture_path(@user), updated_image
          expect(flash[:notice]).to eq("Profile picture updated successfully.")
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end

      context "with no image file provided" do
        it "does not update the profile picture and redirects" do
          updated_image = {user: { image: nil }}
          put update_picture_path(@user), updated_image
          expect(flash[:alert]).to eq("No image file provided.")
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end
    end
  end

end
