class OrdersController < ApplicationController
    before_action :ensure_signed_in!

    def show 
        @order = Order.find(params[:id])
        @purchases = @order.recent_purchases
        @total = @order.total_price
        @user = @order.user
    end

    def create 
        @cart = Cart.find_by(id: session[:cart_id])
        @order = Order.new

        @order.card_number = params[:order][:card_number].last(4) # Save only the last 4 digits
        @order.user = current_user
        @order.save

        @cart.cart_items.each do |item|
            @order.recent_purchases.create(product: item.product, quantity: item.quantity)
            last_purchase = @order.recent_purchases.last

            if not last_purchase.valid?
                flash[:warning] = "Order not placed. #{last_purchase.errors.full_messages.join(", ")}"
                redirect_to cart_path(@cart)
                return
            end
        end

        @cart.cart_items.destroy_all
        redirect_to order_path(@order), notice: "Order placed successfully. Sellers will be contacting you soon."
    end 

    private

end
