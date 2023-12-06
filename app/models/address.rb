class Address < ActiveRecord::Base
  belongs_to :user

  before_create :validate_user_address_limit
  validates :street, presence: true, format: { with: /\A[\w\s,.'-]+\z/, message: "Invalid street format" }
  validates :zip, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "Invalid ZIP code format" }
  validates :state, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "Invalid state format" }
  validates :city, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "Invalid city format" }
  validates :country, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "Invalid country format" }

  private

  def validate_user_address_limit
    if user.addresses.count >= 3
      errors.add(:user, "can only have up to 3 addresses.")
      return false # This halts the callback chain in Rails 4.2 and below
    end
  end
end
