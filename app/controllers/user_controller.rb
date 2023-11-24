class UserController < ApplicationController
  #ensures users are signed in before we try to do :show, :edit, or :update and redirects them to products
  before_action :ensure_signed_in!, only: [:show, :edit, :update]
  #if users aren't logged in when trying to index, send them to the login page.
  before_action :ensure_registration, only: [:index]
  def index
    @user = User.find(params[:id])
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

  #the params to be passed when going to the edit page
  # Now redirects when an incorrect user types in the edit page's path
  def edit
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:warning] = "User not found"
      if @user.id != session[:user_id]
        redirect_to root_path
      end
    end
  end


  # Function to update users after selecting the edit page
  def update
    @user = User.find(params[:id])

    # Select only the parameters that are not blank
    updated_params = user_params.select { |key, value| value.present? }

    if updated_params[:password].blank? && updated_params[:password_confirmation].blank?
      updated_params.delete(:password)
      updated_params.delete(:password_confirmation)
    end

    if @user.update(updated_params)
      # Redirect to a success page
      redirect_to @user
    else
      # Render the form again with error messages
      render :edit
    end
  end

  private
  # marks the user_params
  def user_params
    params.fetch(:user, {}).permit(
      :name, :email, :password, :password_confirmation, :phone_number,
      addresses_attributes: [:id, :address, :street, :zip, :state, :city, :country, :_destroy],
      payments_attributes: [:id, :type, :cc_number, :cc_expr, :cc_name_on_card, :_destroy]
    )
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
