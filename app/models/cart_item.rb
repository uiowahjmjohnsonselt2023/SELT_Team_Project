class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  # validates :quantity, presence: true, numericality: { greater_than: 0 }
  # validates :product_id, presence: true
  # validates :cart_id, presence: true
  
  def total_price
    product.price * quantity
  end

  def total_quantity
    quantity
  end
end
