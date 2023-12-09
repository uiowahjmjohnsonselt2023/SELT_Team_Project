class RecentPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :order
  
  # Add any validations here if needed

  def total
    product.price * quantity
  end
end