class CartItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def total_quantity
    quantity
  end
end
