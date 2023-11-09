class CartProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def total_price  # for a given cart_product, return the total price
    product.price * quantity
  end
end
