class User < ActiveRecord::Base
  
 # attr_accessor :password, :password_confirmation

  before_save { self.email = email.downcase }
  
  validates :name, {
  	presence: true, 
  	length: { maximum: 50 },
  }
  
   VALID_EMAIL_REGEX = /\A([a-z0-9+_]+[.-]?)*[a-z0-9]+@([a-z0-9]+[.-]?)*[a-z0-9]+\.[a-z]+\z/i
  validates :email, {
  	presence:   true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false },
  }

  has_secure_password
  
  validates :password, length: { minimum: 6 }

end