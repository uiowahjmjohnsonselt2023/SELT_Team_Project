class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :authenticate_user_from_remember_token
  before_action :check_session_expiry
  before_action :set_last_accessed_time
  before_action :set_categories, :set_tags
  
  private 
  def check_session_expiry
    if session_expired?
      sign_out
      flash[:warning] = "Your session has expired. Please sign in again."
      redirect_to new_session_path
    end
  end
  def session_expired?
    if user_signed_in?
      last_access_time = session[:last_access_time]
    
      if last_access_time.is_a?(String)
        last_access_time = last_access_time.to_time rescue nil
      end
    
      timeout_period = 60.minutes

      return true unless last_access_time # If last_access_time is nil, return true to indicate the sess
    
      (Time.now - last_access_time) > timeout_period
    end
  end

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
    user.update(loggedIn: true)
    session[:user_id] = user.id
    session[:cart_id] = user.cart.id
  end

  def set_last_accessed_time
    session[:last_access_time] = Time.now
  end

  def sign_out
    current_user.update(loggedIn: false)
    forget(current_user)
    session[:user_id] = nil
    session[:cart_id] = nil
    puts "session user id: #{session[:user_id]}"
  end

  def authenticate_user_from_remember_token
    return unless cookies[:user_id].present? && cookies[:remember_token].present?
    user = User.find_by(id: cookies.signed[:user_id])
    if user && user.authenticated?(cookies[:remember_token])
      sign_in(user)
      set_last_accessed_time
    end
  end

  def set_categories
    @categories = Category.all
  end

  def set_tags
    @product_tags = Tag.all
  end
end
