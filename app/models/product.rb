class Product < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :carts, through: :cart_items
    has_many :product_tags
    has_many :tags, through: :product_tags
    has_many :recent_purchases
    belongs_to :user   

    has_many :reviews
    belongs_to :category

    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images

    validates :name, presence: true, length: {minimum: 3, maximum: 50} 
    validates :price, numericality: { greater_than: 0}
    validates :quantity, presence: true
    validates :description, presence: true, length: {minimum: 10, maximum: 300}
    validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    
    before_save :default_quantity
    before_save :default_description
    before_save :default_category
    before_save :price_format
    before_save :name_format

    before_save { self.archived = true if self.quantity <= 0 }

    def total_quantity
        quantity
    end

    # Getter for tags in comma seperated string
    def tag_list
        self.tags.map(&:name).join(", ")
    end

    # Take a string of comma seperated tags, split into individual tags, and associate w/ product
    def tag_list=(tag_string)
        # Split the tags by comma, makes sure only 3 tags are entered
        tag_names = tag_string.split(",").map(&:strip).reject(&:empty?).uniq.first(3)
        new_or_found_tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
        self.tags = new_or_found_tags
    end

    def discounted_price
        price - (price * discount / 100)
    end

    def self.search(search_term, min_price: nil, max_price: nil, category_id: nil, tag_list: nil, discounted: nil)
        match = all
        # Filter by category
        match = match.where(category_id: category_id) if category_id.present?

        # Filter by tags if tag_list is present
        if tag_list.present?
            # Convert tag_list to lowercase and split into an array
            tags = tag_list.downcase.split(',').map(&:strip).reject(&:empty?).uniq
            match = match.joins(:tags).where('lower(tags.name) IN (?)', tags).distinct
        end

        # Filter by discount
        match = match.where('discount > 0') if discounted.present?

        # Filter by price
        if min_price.present? || max_price.present?
            match = match.to_a.select do |product|
                discounted_price = product.discounted_price
                (min_price.to_f <= discounted_price || min_price.blank?) &&
                  (discounted_price <= max_price.to_f || max_price.blank?)
            end
        end

        # If a search term is provided, filter the results using Levenshtein distance
        if search_term.present?
            match = match.select do |product|
                levenshtein_distance(product.name.downcase, search_term.downcase) <= 3 ||
                  product.name.downcase.include?(search_term.downcase) ||
                  product.description.downcase.include?(search_term.downcase)
            end
        end
        match
    end

    def assign_images(images)
        images.each do |image|
            img = Image.new(image: image, user_id: self.user_id, product_id: self.id)
            if img.valid?
                self.images << img
            else
                return false
            end
        end

        return true
    end
    
    def state
        threshold = 10
        if self.archived
            :archived
        elsif self.quantity == 0
            :out_of_stock
        elsif self.quantity > threshold
            :available
        else
            :low_stock
        end
    end

    private
    def default_quantity # default quantity to 1
        self.quantity ||= 1
    end 

    def default_category
        self.category_id ||= Category.find_by(name: 'Everything else')
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
end
