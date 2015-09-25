class User < ActiveRecord::Base
	# виртуальные атрибуты (не сохраняются в БД)
	attr_accessor :password, :password_confirmation

	before_save { self.email = email.downcase }

	validates :name, { 
		presence: true, 
		length: { maximum: 50 }
	}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :email, {
		presence: true,
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: true,
		uniqueness: { case_sensitive: false },
	}
	
	#has_secure_password
end
