class ProductsController < ApplicationController
    before_action :ensure_signed_in!, only: [:new, :create, :edit, :destroy, :update]
    before_action :ensure_correct_user, only: [:edit, :destroy, :update]
    
    def index 
        @products = Product.all
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
        redirect_to root_path
    end

    def search
        @match = Product.search(params[:search])
        if @match.empty?
            @match = Product.all
            flash.now[:notice] = "No products found."
        end
    end

=begin
    def search
        if params[:search].blank?
            @match = Product.all
        else
            @input = params[:search]
            #@match = Product.all.where("name LIKE ? OR descripton LIKE ?", "%#{@input}%", "%#{@input}%").to_a
            @match = Product.all.select {|product| levenshtein_distance(product.name.downcase, @input.downcase) <= 3 ||
                                          product.name.downcase.include?(@input) ||
                                          product.description.include?(@input)}
            if @match.empty?
                @match = Product.all
                flash.now[:notice] = "No products found."     # Makes sure message would disappear after another search
            end
            if params[:min_price].present?
                min_price = params[:min_price]
                @match = @match.select { |product| product.price >= min_price }
            end
            if params[:max_price].present?
                max_price = params[:max_price]
                @match = @match.select { |product| product.price <= max_price }
            end
            #@match = @match.where("price >= ? AND price <= ?", min_price, max_price)
        end
    end

    def levenshtein_distance(s, t)
        m = s.length
        n = t.length
        return m if n == 0
        return n if m == 0
        d = Array.new(m+1) {Array.new(n+1)}

        (0..m).each {|i| d[i][0] = i}
        (0..n).each {|j| d[0][j] = j}
        (1..n).each do |j|
            (1..m).each do |i|
                d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
                              d[i-1][j-1]       # no operation required
                          else
                              [ d[i-1][j]+1,    # deletion
                                d[i][j-1]+1,    # insertion
                                d[i-1][j-1]+1,  # substitution
                              ].min
                          end
            end
        end
        d[m][n]
    end
=end


    private
    def product_params # TODO: add user_id to product params
        # function to permit only the specified parameters to be passed to the create function
        params.require(:product).permit(:name, :description, :price, :quantity, :user_id)
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

