class Cart < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :products, through: :cart_items
    belongs_to :user

    validates :user_id, uniqueness: true

    def add_product(product_id, quantity = 1) # add product to cart
        current_item = cart_items.find_by(product_id: product_id)
        if current_item
            current_item.quantity += quantity
        else
            current_item = cart_items.new(product_id: product_id, quantity: quantity)
        end

        current_item.save
    end
    
    def total_price                 # calculate total price of all items in cart
        cart_items.to_a.sum { |item| item.total_price }
    end

    def total_quantity              # calculate total quantity of all items in cart
        cart_items.to_a.sum { |item| item.quantity }
    end
end
