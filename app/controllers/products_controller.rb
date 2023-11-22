class ProductsController < ApplicationController
    before_action :ensure_signed_in!, only: [:new, :create, :edit, :destroy, :update]
    before_action :ensure_correct_user, only: [:edit, :destroy, :update]
    
    def index 
        @products = Product.all
        @categories = Category.all
    end

    def show 
        @product = Product.find_by(id: params[:id])
        if @product 
            @user = User.find(@product.user_id)
        else 
            flash['warning'] = "Product not found #{params[:id]}"
            redirect_to root_path
        end
    end

    def update
        @product = Product.find(params[:id])
        if @product.update(product_params)
            redirect_to user_path(@product.user_id), :notice=>"Product updated"
        else
            flash[:warning] = "Product not updated. Try again."
            flash[:errors] = @product.errors.full_messages
            redirect_to edit_product_path
        end
    end

    def new 
        @product = Product.new
    end

    def edit
        # check if product is of the current user, and that it exists 
        @product = Product.find_by(id: params[:id])
        if @product.nil?
            flash[:warning] = "Product not found"
            redirect_to user_path(current_user.id)
        end
    end

    def create 
        @product = Product.create(product_params)
        if @product.valid?
            redirect_to user_path(@product.user_id), :notice=>"Product created"
        else
            flash[:warning] = "Product not created. Try again."
            redirect_to new_product_path 
        end
    end

    def destroy  # TODO: implement check for user_id before destroying product
        @product = Product.find_by(id: params[:id])
        @product.destroy 
        flash[:notice] = "Product deleted"
        redirect_to user_path(current_user.id)
    end

    def search
        # Go back to home page if see all button is clicked
        if params[:see_all]
            session.delete(:search_term)
            redirect_to products_path
        end

        # Store the previous search term if there is any
        session[:search_term] = params[:search] if params[:search].present?
        search_term = session[:search_term]
        min_price = params[:min_price]
        max_price = params[:max_price]
        category_id = params[:category_id]

        @categories = Category.all
        @match = Product.search(search_term, min_price: min_price, max_price: max_price, category_id: category_id)
        if @match.empty?
            @match = Product.all
            flash.now[:notice] = "No products found."
        end
    end

    private
    def product_params # TODO: add user_id to product params
        # function to permit only the specified parameters to be passed to the create function
        params.require(:product).permit(:name, :description, :price, :quantity, :user_id, :category_id)
    end

    def ensure_correct_user
        @product = Product.find_by(id: params[:id])
        if @product && current_user
            if current_user.id != @product.user_id
                flash[:warning] = "You do not have permission to edit this product."
                redirect_to user_path(current_user.id)   # TODO: either redirect to current users path, or redirect to root path
            end
        else 
            flash[:warning] = "Product not found"

        end
    end
end

