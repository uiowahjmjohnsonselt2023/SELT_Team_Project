class UserController < ApplicationController
  before_action :ensure_signed_in!, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
      @user = User.new
      @user.cart = Cart.new
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
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:warning] = "User not found"
      redirect_to root_path
    end
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

  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if not @user 
      flash[:warning] = "Product not found"
      redirect_to root_path
    end

    if current_user.id != @user.id
        flash[:warning] = "You do not have permission to edit this user. Please login to the correct account."
        redirect_to root_path   # TODO: either redirect to current users path, or redirect to root path
    end

end

end
