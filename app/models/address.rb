class Address < ActiveRecord::Base
  belongs_to :user

  before_create :validate_user_address_limit

  private

  def validate_user_address_limit
    if user.addresses.count >= 3
      errors.add(:user, "can only have up to 3 addresses.")
      return false # This halts the callback chain in Rails 4.2 and below
    end
  end
end
