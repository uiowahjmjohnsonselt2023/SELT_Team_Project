class SessionsController < ApplicationController
    def new 
    end
    def create 
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            sign_in(user)
            update_cart(user)
            redirect_to signup_success_path
        else 
            flash[:signin] = "Invalid email or password"
            render :new, satus: :unprocessable_entity
        end
    end

    def destroy
        sign_out
        redirect_to root_path
    end

private
    def update_cart(user)
        cart = Cart.find_by(id: session[:cart_id])
        if cart
            cart.update(user_id: user.id)
        else
            cart = Cart.create(user_id: user.id)
            session[:cart_id] = cart.id
        end
    end 

end
