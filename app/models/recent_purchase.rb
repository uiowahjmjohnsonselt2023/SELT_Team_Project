class RecentPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :order
  
  # Add any validations here if needed

  validate :quantity_cannot_exceed_product_quantity

  def total
    product.price * quantity
  end

  private 
  def quantity_cannot_exceed_product_quantity
    product.quantity -= quantity
    product.save

    if not product.valid? 
      errors.add(:quantity, "can't exceed product quantity")
    end
  end
end