class Product < ActiveRecord::Base
    validates :name, presence: true
    validates :price, presence: true

    # belongs_to :user    #these tables havent been created yet, so the associations are commented out
    # has_many :reviews

    before_save :default_quantity
    before_save :default_description

    def self.search(search_term)
    end
    
    private
    def default_quantity # default quantity to 1
        self.quantity ||= 1
    end 

    def default_description # default description to empty string
        self.description ||= "Default Product Description"
    end
end
