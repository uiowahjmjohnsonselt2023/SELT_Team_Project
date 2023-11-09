class Cart < ActiveRecord::Base
    belongs_to :user  
    has_many :products, through: :cart_products

    def cart_total
        cart_products.to_a.sum { |item| item.total_price }
    end
end
