require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "redirects when users are not logged in" do
      get(users_path)
      expect(response).to redirect_to(signup_path)
    end
  end

  describe "Profile editing flow" do
    it "allows a user to edit and save their profile" do
      sign_in(user)
      visit user_path(user)
      click_link "Edit user settings"

      fill_in "Name", with: "Updated Name"
      click_button "Update"

      expect(page).to have_content("Updated Name")
      # Add more assertions to verify the entire flow
    end
  end

  describe "edit.html.erb" do
    it "displays form with user data" do
      assign(:user, user)
      render
      expect(rendered).to have_selector("input[value='#{user.name}']")
      # Add more assertions for each field
    end
  end

  describe "index.html.erb" do
    it "displays user information" do
      assign(:user, user)
      render
      expect(rendered).to include(user.name)
      # Add more expectations to ensure all necessary info is displayed
    end
  end

  describe "GET /edit" do
    context "when user is signed in" do
      it "renders the edit template" do
        sign_in(user)
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid attributes" do
      it "updates the user and redirects" do
        sign_in(user)
        patch :update, params: { id: user.id, user: { name: "New Name" } }
        user.reload
        expect(user.name).to eq("New Name")
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "with invalid attributes" do
      it "does not update the user and re-renders the edit template" do
        sign_in(user)
        patch :update, params: { id: user.id, user: { email: "invalidemail" } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET /index" do
    context "when user is signed in" do
      before do
        sign_in(user)
        get :index, params: { id: user.id }
      end

      it "responds successfully" do
        expect(response).to be_successful
      end

      it "assigns @user" do
        expect(assigns(:user)).to eq(user)
      end
    end
  end

end
