class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private 
  def ensure_signed_in!
    puts current_user
    unless current_user
      redirect_to root_path 
      flash[:warning] = "You need to sign in before accessing this page." 
    end
  end

  def ensure_registration
    redirect_to signup_path unless current_user
  end

  
  def user_signed_in?
    current_user.present?
  end
  
  def current_user
    if session[:user_id]
      puts "session user id: #{session[:user_id]}"
      User.find_by(id: session[:user_id])
    end
  end
  helper_method :current_user

  def sign_in(user)
    session[:user_id] = user.id
    session[:cart_id] = user.cart.id
  end

  def sign_out
    session[:user_id] = nil
    session[:cart_id] = nil
    puts "session user id: #{session[:user_id]}"
  end
end
