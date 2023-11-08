class UserController < ApplicationController
  def list
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password_digest))
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
end
