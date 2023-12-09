class OrdersController < ApplicationController
    before_action :ensure_signed_in!

    def show 
        @order = Order.find(params[:id])
        @recent_purchases = @order.recent_purchases

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
        end

        @cart.cart_items.destroy_all
        redirect_to order_path(@order)
    end 
end
