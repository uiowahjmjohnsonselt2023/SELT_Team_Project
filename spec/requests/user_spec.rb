require 'rails_helper'

RSpec.describe "Users", type: :request do

  # Test for profile page display when signed in
  describe "GET #show" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        # Manually sign in the user
        sign_in_user(@user)
      end

      it "renders the show template" do
        get user_path(@user)
        expect(response).to render_template(:show)
      end
    end

    context "when user is not signed in" do
      it "redirects to the signup page" do
        get "/users"
        expect(response).to redirect_to(signup_path)
      end
    end
  end

  describe "GET #index" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        # Manually sign in the user
        sign_in_user(@user)
      end

      # it "renders the index template" do
      #   get user_index_path(@user)
      #   expect(response).to render_template(:index)
      # end
    end
  end

  describe "GET #edit" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        # Manually sign in the user
        sign_in_user(@user)
      end

      it "renders the edit template" do
        get edit_user_path(@user)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PUT #update" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        # Manually sign in the user
        sign_in_user(@user)
      end

      it "updates the user and redirects to show template" do
        updated_params = { user: { name: "New Name", email: @user.email, phone_number: @user.phone_number } }
        put update_user_path(@user), updated_params
        @user.reload
        expect(@user.name).to eq("New Name")
        expect(response).to redirect_to(edit_user_path(@user))
      end

      context "with invalid attributes" do
        it "does not change @user's attributes and re-renders the edit template" do
          put user_path(@user), params: { user: { name: nil } }
          @user.reload
          expect(@user.name).not_to eq(nil)
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end
    end
  end

  describe "PUT #update_password" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        sign_in_user(@user)
      end

      context "with valid password parameters" do
        it "updates the user's password and redirects to the edit user path" do
          updated_password =  {user: { password: 'newpassword', password_confirmation: 'newpassword' } }
          put update_password_path(@user), updated_password
          expect(flash[:notice]).to eq("password updated successfully.")
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end

      context "with invalid password parameters" do
        it "does not update the user's password and redirects to the edit user path" do
          bad_password =  {user: { password: 'newpassword', password_confirmation: 'mismatch' } }
          put update_password_path(@user), bad_password
          expect(flash[:notice]).to eq("password not successfully.")
          expect(response).to redirect_to(edit_user_path(@user))
        end
      end
    end
  end

  describe "POST #update_or_create_address" do
    context "when user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        sign_in_user(@user)
      end

      context "when creating a new address" do
        new_address = {user: { street: '123 Test St', city: 'Testville', state: 'TS', zip: '12345', country: 'Testland' } }

        it "creates a new address for the user and redirects to the edit user path" do
          new_address = { street: '123 Test St', city: 'Testville', state: 'TS', zip: '12345', country: 'Testland' }
          post update_address_path(@user), new_address
          expect(@user.addresses.count).to eq(1)
          expect(response).to redirect_to(edit_user_path(@user))
          expect(flash[:notice]).to eq("Address updated/created successfully.")
        end
      end

      context "when updating an existing address" do
        before do
          @address = @user.addresses.create(address_params)
        end

        let(:address_params) { { street: '456 Updated St', city: 'Newville', state: 'NS', zip: '67890', country: 'Newland' } }

        it "updates the existing address for the user and redirects to the edit user path" do
          post update_address_path(@user), params: address_params.merge(address_index: 1)
          @address.reload
          expect(@address.street).to eq('456 Updated St')
          expect(response).to redirect_to(edit_user_path(@user))
          expect(flash[:notice]).to eq("Address updated/created successfully.")
        end
      end

      context "with invalid address parameters" do
        it "does not create or update the address and redirects to the edit user path" do
          post update_address_path(@user), params: { street: '' } # Intentionally missing other params
          expect(response).to redirect_to(edit_user_path(@user))
          expect(flash[:alert]).to eq("Error updating/creating address.")
        end
      end
    end
  end

  describe "before_action :ensure_correct_user" do
    context "when a wrong user is signed in" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        sign_in_user(@user)
      end

      it "redirects the user to the root path with a flash warning" do
        get edit_user_path(@other_user)
        expect(response).to redirect_to(root_path)
        expect(flash[:warning]).to eq("You do not have permission to edit this user. Please login to the correct account.")
      end
    end
  end

  # Helper method for signing in users
  def sign_in_user(user)
    post sessions_path, params: { session: { email: user.email, password: 'password' } }
    session[:user_id] = user.id
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:ensure_signed_in!).and_return(true)
  end

end
