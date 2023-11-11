class UserController < ApplicationController

  def index
    @user = User.all
  end


  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      # Redirect to a success page
      render :user
    else
      # Render the form again with error messages
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :phone, :email, :card_number, :street_address, :apt, :city, :state, :zip, :expiry, :cvc)
  end

  # A deprecated test function that never got finished. Do not use - will be removed at a later date.
  def flash_test
    redirect_to :action => :index
    flash[:notice] = "Test Flash, for dev purposes only."
  end

end
