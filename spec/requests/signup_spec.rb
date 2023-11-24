require 'rails_helper'

RSpec.describe "Signups", type: :request do
  describe "GET #new" do
    it "renders the new template" do
      get signup_path
      expect(response).to render_template(:new)
    end

    it "assigns a new user to @user" do
      get signup_path
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid user params" do
      before(:each) do
        @valid_params = { user: FactoryBot.attributes_for(:user) }
      end

      it "creates a new user" do
        # check if there was a change in User size
        expect {
          post signup_path, @valid_params
        }.to change(User, :count).by(1)

      end

      it "signs in the user" do
        post signup_path, @valid_params
        expect(session[:user_id]).to eq(User.last.id)
      end

      it "redirects to signup_success_path" do
        post signup_path, @valid_params
        expect(response).to redirect_to(signup_success_path)
      end
    end

    context "with invalid user params" do
      before(:each) do
        @invalid_params = { user: FactoryBot.attributes_for(:user, email: "invalid-email") }
      end
    
      it "does not create a new user" do
        expect {
          post signup_path, @invalid_params
        }.not_to change(User, :count)
      end

      it "renders the new template with unprocessable_entity status" do
        post signup_path, @invalid_params

        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
      end
    end
  end
end
