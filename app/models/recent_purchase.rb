class RecentPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # Add any validations here if needed
end