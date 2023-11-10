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
        if params[:search].blank?
            @match = Product.all
        else
            @input = params[:search]
            #@match = Product.all.where("name LIKE ? OR descripton LIKE ?", "%#{@input}%", "%#{@input}%").to_a
            @match = Product.all.select {|product| levenshtein_distance(product.name.downcase, @input.downcase) <= 3 ||
                                          product.name.downcase.include?(@input) ||
                                          product.descripton.include?(@input)}
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
        render 'show'
    end

    # From https://stackoverflow.com/questions/16323571/measure-the-distance-between-two-strings-with-ruby
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
end

