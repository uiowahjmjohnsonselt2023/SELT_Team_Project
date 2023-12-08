class User < ApplicationRecord
    has_secure_password
    attr_accessor :remember_token

    #before_save {|user| user.email = user.email.downcase}
    validates :name, presence: true, length: {maximum: 25}
    VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: false, scope: :login_type}
    validates :password, presence: true, length: {minimum: 6}, if: :required_password?
    validates :password_confirmation, presence: true, if: :required_password?

    #after_save :create_session_token
    has_many :products, dependent: :destroy
    has_one :cart, dependent: :destroy
    has_many :addresses, dependent: :destroy
    has_many :recent_purchases, dependent: :destroy


    before_save { self.cart = Cart.create(user_id: self.id) if self.cart.nil? }

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def forget 
        update_attribute(:remember_digest, nil)
    end

    def authenticated?(token)
        BCrypt::Password.new(remember_digest).is_password?(token)
    end

    validate :validate_addresses_limit
    private

    def validate_addresses_limit
        errors.add(:addresses, "You can only have up to 3 addresses.") if addresses.count > 3
    end
    def required_password?
        new_record? || password.present?
    end

    def self.new_token
        SecureRandom.urlsafe_base64
    end

    def self.digest(token)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(token, cost: cost)
    end

end
