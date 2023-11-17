class Product < ApplicationRecord
    has_many :cart_items
    has_many :carts, through: :cart_items
    belongs_to :user   
    has_many :reviews
    belongs_to :category

    validates :name, presence: true, length: {minimum: 3, maximum: 50} 
    validates :price, numericality: { greater_than: 0}
    validates :quantity, presence: true
    validates :description, presence: true
    

    before_save :default_quantity
    before_save :default_description
    before_save :price_format
    before_save :name_format


    # From https://stackoverflow.com/questions/16323571/measure-the-distance-between-two-strings-with-ruby
    def self.levenshtein_distance(s, t)
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

    def self.search(search_term, min_price: nil, max_price: nil)
        match = if search_term.blank?
                    all
                else
                    all.select do |product|
                        levenshtein_distance(product.name.downcase, search_term.downcase) <= 3 ||
                          product.name.downcase.include?(search_term) ||
                          product.description.include?(search_term)
                    end
                end
        match = match.select { |product| product.price >= min_price } if min_price.present?
        match = match.select { |product| product.price <= max_price } if max_price.present?
        match
    end

    private
    def default_quantity # default quantity to 1
        self.quantity ||= 1
    end 

    def default_description # default description to empty string
        self.description ||= "Default Product Description"
    end

    def name_format # format name to title case
        self.name = self.name.titleize
        if name !~ /\A[a-zA-Z]+\z/
            errors.add(:name, "can only contain letters")
        end
    end

    def price_format # format price to 2 decimal places
        self.price = price.round(2)
    end
end
