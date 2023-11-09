class ProductController < ApplicationController
    def index 

    end

    def show 
        @product = Product.find(params[:id])
    end

    def create 
        @product = Product.new(params.require(:product).permit(:name, :description, :price, :quantity))
        if @product.save
            redirect_to @product
        else
            render 'new'
        end
    end

    def search 
        render :show # temporary
    end 
end

