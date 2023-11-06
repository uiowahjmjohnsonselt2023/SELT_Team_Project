class User < ActiveRecord::Base
    has_secure_password
    has_many :reviews
    has_many :payment_methods
    has_many :addresses
    has_many :products
    has_one :cart
    
    validates :name, presence: true
    validates :password_digest, presence: true
    validates :email, presence: true
    validates :phone_number, presence: true
    validates :verified_seller, presence: true
    validates :rating, presence: true
    validates :profile_picture, presence: true
    
end
