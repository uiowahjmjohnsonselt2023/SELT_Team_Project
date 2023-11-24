class CartItem < ApplicationRecord
    belongs_to :product, required: true
    belongs_to :cart

    validates :product_id, presence: true, uniqueness: { scope: :cart_id }
    validates :cart_id, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validate :quantity_cannot_exceed_product_quantity
    
    # TODO: Determine how to ensure this line doesn't get reached if product_id is nil
    before_save :update_product_quantity

    def total_price
      product.price * quantity
    end

    def total_quantity
      quantity
    end

    private 
    def quantity_cannot_exceed_product_quantity
      if product.present? && quantity.present?
        errors.add(:quantity, "can't exceed product quantity") if quantity > product.quantity
      end
    end

    def update_product_quantity
      if product.quantity >= quantity
          product.quantity -= quantity
          product.save
      else 
          errors.add(:quantity, "can't exceed product quantity")
      end
    end
  end
