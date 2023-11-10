class CartsController < ApplicationController
    def show
        # find a cart by id, if not create one 
        @cart = Cart.find_by(id: session[:cart_id])

        if @cart.cart_items.empty?
            @cart_items = []
        else
            @cart_items = @cart.cart_items
        end
    end

    def add
        @product = Product.find(params[:product_id])
        quantity = params[:quantity].to_i

        current_item = @cart.cart_items.find_by(product_id: @product.id)

        if current_item && current_item.quantity > 0
            current_item.quantity += quantity
        else 
            @cart.cart_items.create(product: @product, quantity: quantity)
        end

        redirect_to :back
    end

    def remove 
        @cart.cart_items.find_by(product_id: params[:product_id]).destroy
        flash[:notice] = "Product removed from cart"
        redirect_to :back
    end
end
