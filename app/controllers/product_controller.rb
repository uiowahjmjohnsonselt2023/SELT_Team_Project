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
        # set default value for min and max
        min_price = params[:min_price].presence || '0'
        max_price = params[:max_price].presence || '10000000'
        if params[:search].blank?
            @match = Product.all
        else
            @input = params[:search]
            @match = Product.where("name LIKE ? OR descripton LIKE ?", "%#{@input}%", "%#{@input}%")
            if @match.empty?
                @match = Product.all
                flash.now[:notice] = "No products found."     # Makes sure message would disappear after another search
            end
        end
        @match = @match.where("price >= ? AND price <= ?", min_price, max_price)
        render 'show'
    end 
end

