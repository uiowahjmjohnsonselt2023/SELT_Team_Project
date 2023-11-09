class CartController < ApplicationController
    def add
        @product = Product.find(params[:id])
        # determine if the product exists in the cart
    end

    def get
        @cart = session[:cart_id] || {}
    end

    def remove
        id = params[:id]
        session[:cart].remove_item(id)
        redirect_to :action => :show
    end

    def clear
        
    end
end
