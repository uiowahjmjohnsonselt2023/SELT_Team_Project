class Product < ApplicationRecord
    has_many :cart_items
    has_many :carts, through: :cart_items
    belongs_to :user   
    has_many :reviews

    validates :name, presence: true, length: {minimum: 3, maximum: 50} 
    validates :price, numericality: { greater_than: 0}
    validates :quantity, presence: true
    validates :description, presence: true
    

    before_save :default_quantity
    before_save :default_description
    before_save :price_format
    before_save :name_format

    def self.search(search_term)
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
