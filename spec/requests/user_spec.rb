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
        @admin = FactoryBot.create(:user, :admin)
        @category = FactoryBot.create(:category, name: 'test')
        @product = FactoryBot.create(:product)
        sign_in_user(@admin)
      end


      #test that an admin can view the page
      it "they can view the page" do
        get admin_path(@admin)
        response.status.should be(200)
      end
      it "displays the top tags" do
        get admin_path(@admin)
        expect(assigns(:pop_tag)).to eq([["Sample tag1", 14], ["Sample tag2", 14]])
        expect(assigns(:best_tag)).to eq("Sample tag1")
      end
      it "displays the top categories" do
        expect(assigns(:pop_cat)).to eq(["Sporting Goods" => 1])
        expect(assigns(:best_cat)).to eq("Sporting Goods")
      end
    end

    context "when user is not an admin" do
      before do
        @user = FactoryBot.create(:user)
        sign_in_user(@user)
      end

      it "redirect to root" do
        get admin_path(@user)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PUT #search" do
    before do
      @admin = FactoryBot.create(:user, :admin)
      @user = User.create(name: "test", email: "test@test.com", password: "password", password_confirmation: "password", admin: false)
      sign_in_user(@admin)
      sign_in_user(@user)
    end
    context "When an admin is logged in with multiple users" do
      it "assigns the results to search_res" do
        post '/user_search', params: {search: @user.email}
        response.status.should be(200)
        expect(assigns(:search_res)).to be_present
      end

    end
  end


  describe "PUT #promote" do
    before do
      @admin = FactoryBot.create(:user, :admin)
      @user = User.create(name: "test", email: "test@test.com", password: "password", password_confirmation: "password", admin: false)
      Rails.logger.info(@user)
      Rails.logger.info(@user.id)
      sign_in_user(@admin)

    end
    context "When an admin is logged in with multiple users" do
      it "a regular user can be promoted" do
        id_test = @user.id
        Rails.logger.info(id_test)
        put promote_path, params: {id: id_test}
        @user.reload
        expect(@user.admin).to eq(true)
      end
    end
  end


end