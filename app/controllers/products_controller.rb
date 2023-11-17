class ProductsController < ApplicationController
    def index 
        @products = Product.all
    end

    def show 
        # check if params[:id] is number   
        @product = Product.find(params[:id])
        @user = User.find(@product.user_id)
    end

    def new 
        @product = Product.new
    end

    def edit
    end

    def create 
        @product = Product.create(product_params)
        if @product.valid?
            redirect_to :action=>'show', :id=>@product.id, :notice=>"Product created"
        else
            flash[:warning] = ("Product not created. Try again.")
            redirect_to new_product_path , flash[:warning] = "Product not created. Try again."
        end
    end

    def destroy  # TODO: implement check for user_id before destroying product
        @product.destroy 
        flash[:notice] = "Product deleted"
    end

    def search
        # Store the previous search term if there is any
        session[:search_term] = params[:search] if params[:search].present?

        search_term = session[:search_term]
        min_price = params[:min_price]
        max_price = params[:max_price]
        @match = Product.search(search_term, min_price: min_price, max_price: max_price)
        @categories = Category.all
        if @match.empty?
            @match = Product.all
            flash.now[:notice] = "No products found."
        end
    end

    private
    def product_params # TODO: add user_id to product params
        # function to permit only the specified parameters to be passed to the create function
        params.require(:product).permit(:name, :description, :price, :quantity, :user_id)
    end
end

