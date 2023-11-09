class ProductsController < ApplicationController
    def index 
        @products = Product.all
    end

    def show 
        @product = Product.find(params[:id])
    end

    def new 
        @product = Product.new
    end

    def edit
    end

    def create 
        @product = Product.new(product_params)
        if @product.save
            flash[:success] = "Product created"
            redirect_to product_path(@product)
        else
            flash[:warn] = "Product not created. Try again."
            render 'new'
        end
    end

    def search  # TODO: implement product searching via keywords 
        puts "searching for #{params[:search]}"
                # @products = Product.search(params[:search])
        @products = []
    end     

    def destroy  # TODO: implement check for user_id before destroying product
        @product.destroy 
        flash[:success] = "Product deleted"
    end
    
    private
    def product_params # TODO: add user_id to product params
        # function to permit only the specified parameters to be passed to the create function
        params.require(:product).permit(:name, :description, :price, :quantity)
    end
end

