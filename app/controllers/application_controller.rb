class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_action :initialize_cart

  # private
  # def initialize_cart 
  #   @cart ||= Cart.find_by(id: session[:cart_id]) # find a users cart by their session id

  #   if @cart.nil?   # if this is a new session create a new cart and assign it to the session
  #     @cart = Cart.create
  #     session[:cart_id] = @cart.id
  #   end
  # end
end
