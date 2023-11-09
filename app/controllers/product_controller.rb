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
        #@product = Product.all.where("lower(name) LIKE :search", search: "%#{params[:search].downcase}%")
        @input = params[:search]
        @match = Product.where("name LIKE ?", "%#{@input}%")
        render 'show'
    end 
end

