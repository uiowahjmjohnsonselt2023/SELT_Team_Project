class MainController < ApplicationController
    def index
        @products = Product.all
    end

    def add_to_cart
        id = params[:id]
        cart = session[:cart] ||= {} 
        cart[id] = (cart[id] || 0) + 1 # increment the number of this product in the cart
        redirect_to :action => :index
        
        flash[:notice] = "Added " << Product.find(id).name << " to cart. Size of cart: " << cart.values.sum.to_s
    end

    def get_cart
        @cart = session[:cart] || {}
    end
end
