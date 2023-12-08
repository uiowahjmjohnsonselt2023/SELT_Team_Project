class SignupController < ApplicationController
  include SessionsHelper
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
      if @user.save
        sign_in(@user)
        params[:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_to signup_success_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation).merge(login_type: "standard", admin: false)
    end
end