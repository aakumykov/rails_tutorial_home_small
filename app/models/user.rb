class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "reader_id", dependent: :destroy
	has_many :author_users, through: :relationships, source: :author

	before_create :create_remember_token
	before_save { email.downcase! }
	
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


	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end


	def feed
		# Это предварительное решение. См. полную реализацию в "Following users".
		Micropost.where("user_id = ?", id)
	end


	def reader?(other_user)
		relationships.find_by(author_id: other_user.id)
	end

	def read!(other_user)
		relationships.create!(author_id: other_user.id)
	end

	def unread!(other_user)
		relationships.find_by(author_id: other_user.id).destroy!
	end


	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
		
end