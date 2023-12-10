class UserController < ApplicationController
  #ensures users are signed in before we try to do :show, :edit, or :update and redirects them to products
  before_action :ensure_signed_in!, only: [:show, :edit, :update]
  #if users aren't logged in when trying to index, send them to the login page.
  before_action :ensure_registration, only: [:index]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @address = @user.addresses
    @product = @user.products
    @recent_purchases = @user.recent_purchases
    @image = @user.image
  end

  # :nocov:
  def new
      @user = User.new
      @user.cart = Cart.new
  end
  
  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    @user.images.create(image: image, user_id: self.user_id)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
  # :nocov:


  #the params to be passed when going to the edit page
  # Now redirects when an incorrect user types in the edit page's path
  def edit
    @user = User.find_by(id: params[:id])
    @address = @user.addresses || @user.addresses.build
    @image = @user.image
    if @user.nil?
      flash[:warning] = "User not found"
      if @user.id != session[:user_id]
        redirect_to root_path
      end
    end
    @address = @user.addresses || @user.addresses.build
  end

  # GET /users/:id/addresses - for displaying addresses in edit page
  def addresses
    @user = User.find(params[:id])
    render json: @user.addresses
  end


  # Function to update users after selecting the edit page
  def update
    @user = User.find(params[:id])
    # Select only the parameters that are not blank
    updated_params = user_params.select { |key, value| value.present? }
    if @user.login_type == "standard"
      if @user.update(updated_params)
        # Redirect to a success page
        redirect_to edit_user_path(@user), notice: "User info updated successfully."
      else
        # Render the form again with error messages
        redirect_to edit_user_path(@user), alert: "Error updating info."
      end
    else
      redirect_to edit_user_path(@user),  alert: "Can not change userinfo when logged in from google/github."
    end

  end

  def update_picture
    @user = User.find(params[:id])
    image_file = profile_picture_upload[:image]

    if image_file
      errors = @user.assign_image(image_file)
      if errors.empty?
        redirect_to edit_user_path(@user), notice: "Profile picture updated successfully."
      else
        # Pass the errors to the view
        flash.now[:alert] = errors.join(', ')
        render 'edit'
      end
    else
      redirect_to edit_user_path(@user), alert: "No image file provided."
    end
  end


  def update_password
    @user = User.find(params[:id])
    if @user.login_type == "standard"
      if @user.update(password_params)
        # Redirect to a success page
        redirect_to edit_user_path(@user), notice: "password updated successfully."
      else
        # Render the form again with error messages
        redirect_to edit_user_path(@user),  alert: "password could not be updated successfully."
      end
    else
      redirect_to edit_user_path(@user),  alert: "Can not change userinfo when logged in from google/github."
    end
  end

  def update_or_create_address
    @user = User.find(params[:id]) # Ensure you have the user's ID
    address_index = (params[:address_index].to_i) + 1

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

  # :nocov:
  def update_payment
    @user = User.find(params[:id]) # Ensure you have the user's ID
    redirect_to edit_user_path(@user), notice: "You tried to update payment lol."
  end
  # :nocov:

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

  def profile_picture_upload
    params.require(:user).permit(:image)
  end

  # :nocov:
  def payment_params
    params.require(:user).permit(:cc_number, :cc_expr, :cc_name_on_card)
  end


  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if not @user
      flash[:warning] = "User not found"
      redirect_to root_path
    end
    # :nocov:

    if current_user.id != @user.id
        flash[:warning] = "You do not have permission to edit this user. Please login to the correct account."
        redirect_to root_path   # TODO: either redirect to current users path, or redirect to root path
    end

end

end
