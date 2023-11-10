class User < ActiveRecord::Base
    has_secure_password
    before_save { self.email = email.downcase }

    validates :name, presence: true
    validates :email, presence: true
    validates :password, presence: true
    validates :password_confirmation, presence: true
    
    has_many :products
    # has_many :reviews
end
