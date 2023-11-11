class ApplicationController < ActionController::Base
  before_action :initialize_cart
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private 
  def initialize_cart
    @cart ||= Cart.find_by(user_id: session[:session_id])  # if cart exists, set @cart to cart, else create new cart
    if @cart.nil?
      puts "New User: cart created"
      @cart = Cart.create(user_id: session[:session_id])
      session[:cart_id] = @cart.id    # set session cart_id to the current cart_id
    end
  end 

  def ensure_signed_in!
    redirect_to root_path unless current_user
  end
  
  def user_signed_in?
    current_user.present?
  end
  
  def current_user
    if session[:user_id]
      User.find_by(id: session[:user_id])
    end
  end
  helper_method :current_user

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def update_cart(user)
    puts user.inspect
    # find the cart_id that is associated with the session 
    # if the cart exists update the user_id to the current user
    cart = Cart.find_by(id: session[:cart_id])
    if cart
        cart.update(user_id: user.id)
    else
        cart = Cart.create(user_id: user.id)
        session[:cart_id] = cart.id
    end
end 
end
