class Order < ActiveRecord::Base
    has_many :recent_purchases
    has_many :products, through: :recent_purchases
    belongs_to :user

    has_one :addresses, as: :address, through: :user

    def total_price
        recent_purchases.inject(0) { |sum, purchase| sum + purchase.total }
    end

    def order_size
        recent_purchases.inject(0) { |sum, purchase| sum + purchase.quantity }
    end
end
