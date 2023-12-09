class CartsController < ApplicationController
    before_action :ensure_signed_in! 
    before_action :ensure_cart_owner, only: [:show, :destroy, :add]

    def show
        # find a cart by id, if not create one 
        @cart = Cart.find_by(id: session[:cart_id])
        @user = @cart.user

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
        respond_to do |format|   
            current_item = cart.add_product(product.id, quantity)   # add product determines if the input params are valid
            if current_item.valid?
                format.html { redirect_to :back, notice: "Added #{quantity} #{current_item.product.name}(s) to your cart" }
                format.js
            else
                format.html { redirect_to :back, warning: "Sorry, you can only add up to #{current_item.product.quantity} of #{current_item.product.name} to your cart." }
                format.js { render 'add_error' }
            end
            
           
        end
    end

    def destroy 
        @cart = Cart.find_by(id: session[:cart_id])
        @current_item = @cart.cart_items.find_by(product_id: params[:product_id])

        remove_quantity = params[:quantity].to_i
        total_quantity = @current_item.quantity
        @item_id = @current_item.id

        respond_to do |format|
            if remove_quantity > total_quantity
                remove_quantity = total_quantity
            end
            @current_item.quantity -= remove_quantity
            @current_item.save
            if @current_item.quantity == 0
                @current_item.destroy
            end
        
            format.html { redirect_to :back , notice: "Removed #{remove_quantity} #{@current_item.product.name}(s) from your cart" }
            format.js 
        end
    end

    def checkout 
    end 

    private 
    def ensure_cart_owner
        if not current_user 
                flash[:warning] = "You need to sign in before accessing this page."
                redirect_to root_path
        end

        if current_user.cart.id != session[:cart_id]
            flash[:warning] = "You do not have access to this cart. #{session[:cart_id]}"
            redirect_to root_path
        end
    end 
end
