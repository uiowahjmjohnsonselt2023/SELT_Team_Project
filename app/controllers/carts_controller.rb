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
        @cart = Cart.find_by(id: session[:cart_id])

        quantity = params[:quantity].to_i
        current_item = @cart.cart_items.find_by(product_id: @product.id)

        if current_item && current_item.quantity > 0
            current_item.quantity += quantity
            current_item.save
        else 
            @cart.cart_items.create(product: @product, quantity: quantity)
        end

        flash[:notice] = "Product added to cart"

        redirect_to :root
    end

    def remove 
        current_item = @cart.cart_items.find_by(product_id: params[:product_id])
        remove_quantity = params[:quantity].to_i
        total_quantity = current_item.quantity

        if remove_quantity >= total_quantity # if the number of items to remove is greater than the total numbers of unit items. Destroy the cart item
            current_item.destroy
            flash[:notice] = "Product removed from cart"
        else 
            current_item.quantity -= remove_quantity
            current_item.save
            flash[:notice] = "Removed #{remove_quantity} #{current_item.product.name}(s) from your cart" #TODO: dynamic pluralization of product name
        end

        redirect_to :back
    end
end
