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
        @product.save
        puts "product_params: #{product_params}"
        if @product.valid?
            redirect_to :action=>'show', :id=>@product.id, :notice=>"Product created"
        else
            flash[:warning] = ("Product not created. Try again.")
            redirect_to new_product_path , flash[:warning] => "Product not created. Try again."
        end
    end

    def search  # TODO: implement product searching via keywords 
        puts "searching for #{params[:search]}"
                # @products = Product.search(params[:search])
        @products = []
    end     

    def destroy  # TODO: implement check for user_id before destroying product
        @product.destroy 
        flash[:notice] = "Product deleted"
    end
    
    private
    def product_params # TODO: add user_id to product params
        # function to permit only the specified parameters to be passed to the create function
        params.require(:product).permit(:name, :description, :price, :quantity, :user_id)
    end
end

