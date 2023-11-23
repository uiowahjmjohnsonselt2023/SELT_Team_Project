class UserController < ApplicationController


  #ensures users are signed in before we try to do :show, :edit, or :update and redirects them to products
  before_action :ensure_signed_in!, only: [:show, :edit, :update]
  #if users aren't logged in when trying to index, send them to the login page.
  before_action :ensure_registration, only: [:index]
  def index
    @user = User.find(params[:id])
    @address = @user.addresses
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

  #the params to be passed when going to the edit page
  # Now redirects when an incorrect user types in the edit page's path
  def edit
    @user = User.find(params[:id])
    @address = @user.addresses
    if @user.id != session[:user_id]
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
      redirect_to user_path(@user), notice: "User info updatedsuccessfully."
    else
      # Render the form again with error messages
      redirect_to edit_user_path(@user), alert: "Error updating info."
    end
  end

  def update_or_create_address
    @user = User.find(params[:user_id]) # Ensure you have the user's ID
    address_index = params[:address_index].to_i

    address = @user.addresses[address_index] || @user.addresses.build
    address.assign_attributes(address_params)

    if address.save
      redirect_to user_path(@user), notice: "Address updated/created successfully."
    else
      redirect_to edit_user_path(@user), alert: "Error updating/creating address."
    end
  end

  private
  # marks the user_params
  def user_params
    params.fetch(:user, {}).permit(:name, :email, :password, :password_confirmation, :phone_number)
  end

  def address_params
    params.permit(:street, :city, :state, :zip, :country)
  end


end
