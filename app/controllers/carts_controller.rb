class CartsController < ApplicationController
    before_action :ensure_signed_in! 
    before_action :ensure_cart_owner, only: [:show, :destroy, :add]

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
        product = Product.find(params[:product_id])
        cart = Cart.find_by(id: session[:cart_id])
        
        quantity = params[:quantity].to_i

        current_item = cart.add_product(product.id, quantity)   # add product determines if the input params are valid

        if current_item
            flash[:notice] = "Product added to cart"
        else
            flash[:warning] = "Sorry, you can only add up to #{current_item.product.quantity} of #{current_item.product.name} to your cart."
        end
      
        redirect_to :back
    end

    def destroy 
        @cart = Cart.find_by(id: session[:cart_id])
        current_item = @cart.cart_items.find_by(product_id: params[:product_id])
        remove_quantity = params[:quantity].to_i
        total_quantity = current_item.quantity

        if remove_quantity >= total_quantity # if the number of items to remove is greater than the total numbers of unit items. Destroy the cart item
            current_item.destroy
            flash[:notice] = "Product removed from cart"
        else 
            current_item.quantity -= remove_quantity
            current_item.product.quantity += remove_quantity
            current_item.save
            flash[:notice] = "Removed #{remove_quantity} #{current_item.product.name}(s) from your cart" #TODO: dynamic pluralization of product name
        end

        redirect_to :back
    end

    private 
    def ensure_cart_owner
        if not current_user 
                flash[:warning] = "You need to sign in before accessing this page."
                redirect_to root_path
        end

        if current_user.cart.id != session[:cart_id]
            flash[:warning] = "You do not have access to this cart."
            redirect_to root_path
        end
    end 
end
