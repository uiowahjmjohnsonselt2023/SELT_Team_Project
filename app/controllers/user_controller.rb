class UserController < ApplicationController


  #ensures users are signed in before we try to do :show, :edit, or :update and redirects them to products
  before_action :ensure_signed_in!, only: [:show, :edit, :update]
  #
  before_action :ensure_registration, only: [:index]
  def index
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    # Select only the parameters that are not blank
    updated_params = user_params.select { |key, value| value.present? }

    if @user.update(updated_params)
      # Redirect to a success page
      redirect_to @user
    else
      # Render the form again with error messages
      render :edit
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(
      :name, :email, :password, :password_confirmation, :phone_number,
      addresses_attributes: [:id, :address, :street, :zip, :state, :city, :country, :_destroy],
      payments_attributes: [:id, :type, :cc_number, :cc_expr, :cc_name_on_card, :_destroy]
    )
  end


end
