class UserController < ApplicationController
  #ensures users are signed in before we try to do :show, :edit, or :update and redirects them to products
  before_action :ensure_signed_in!, only: [:show, :edit, :update]
  #if users aren't logged in when trying to index, send them to the login page.
  before_action :ensure_registration, only: [:index]

  def index
    @user = User.find(params[:id])
    @address = @user.addresses
    @product = @user.products
    @recent_purchases = @user.recent_purchases
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.cart = Cart.new
  end

  # meant to be used to search for users on the admin page, or for any other implementation we want?
  # not sure if this will be our final version of this.
  def search
    email_search = params[:search]
    @matches = User.where(email: email_search)
    if @matches.empty?
      flash[:warning] = "No Matches found"
    end
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
    @address = @user.addresses || @user.addresses.build
    if @user.nil? or @user.id != session[:user_id]
      flash[:warning] = "User not found"
      redirect_to root_path
    end
  end


  def admin
    @user = User.find_by(id: params[:id])
    if @user.admin != true
      flash[:warning] = "User is not an admin"
      redirect_to root_path
    end
  end


  # Function to update users after selecting the edit page
  def update
    @user = User.find(params[:id])
    # Select only the parameters that are not blank
    updated_params = user_params.select { |key, value| value.present? }
    if @user.update(updated_params)
      # Redirect to a success page
      redirect_to edit_user_path(@user), notice: "User info updated successfully."
    else
      # Render the form again with error messages
      redirect_to edit_user_path(@user), notice: "Error updating info."
    end
  end

  def update_password
    @user = User.find(params[:id])

    if @user.update(password_params)
      # Redirect to a success page
      redirect_to edit_user_path(@user), notice: "password updated successfully."
    else
      # Render the form again with error messages
      redirect_to edit_user_path(@user),  notice: "password not successfully."
    end
  end

  def update_or_create_address
    @user = User.find(params[:id]) # Ensure you have the user's ID
    address_index = (params[:address_index].to_i) - 1

    if @user.addresses[address_index].present?
      address = @user.addresses.limit(3)[address_index]
    else
      address = @user.addresses.build
    end

    address.assign_attributes(address_params)
    if address.save
      redirect_to edit_user_path(@user), notice: "Address updated/created successfully."
    else
      redirect_to edit_user_path(@user), alert: "Error updating/creating address."
    end
  end

  private
  # marks the user_params
  def user_params
    params.fetch(:user, {}).permit(:name, :email, :phone_number)
  end

  def address_params
    params.permit(:street, :city, :state, :zip, :country)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end


  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if not @user 
      flash[:warning] = "User not found"
      redirect_to root_path
    end

    if current_user.id != @user.id
        flash[:warning] = "You do not have permission to edit this user. Please login to the correct account."
        redirect_to root_path   # TODO: either redirect to current users path, or redirect to root path
    end

end

end
