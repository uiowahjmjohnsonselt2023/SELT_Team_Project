class User < ApplicationRecord
    has_secure_password
    #before_save {|user| user.email = user.email.downcase}
    validates :name, presence: true, length: {maximum: 25}
    VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: false}
    validates :password, presence: true, length: {minimum: 6}, if: :required_password?
    validates :password_confirmation, presence: true, if: :required_password?
    #validates :reviews, presence: true

    #after_save :create_session_token
    has_many :products
    has_one :cart
    has_many :addresses
    has_many :recent_purchases

    validate :validate_addresses_limit
    private

    def validate_addresses_limit
        errors.add(:addresses, "You can only have up to 3 addresses.") if addresses.count > 3
    end
    def required_password?
        new_record? || password.present?
    end
# private 
#     def create_session_token
#         self.session_token = SessionRandom.urlsafe_base64
#     end
end
