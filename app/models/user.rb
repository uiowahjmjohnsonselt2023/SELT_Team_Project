class User < ActiveRecord::Base
    has_secure_password
    before_save {|user| user.email = user.email.downcase}
    #before_save :create_session_token
    validates :name, presence: true, length: {maximum: 25}
    VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: false}
    validates :password, presence: true, length: {minimum: 6}
    validates :password_confirmation, presence: true

private 
    def create_session_token
        self.session_token = SessionRandom.urlsafe_base64
    end
end
