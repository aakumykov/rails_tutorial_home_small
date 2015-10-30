class Micropost < ActiveRecord::Base
	belongs_to :user
	
	default_scope -> { order('created_at DESC') }
	
	validates :user_id, presence: true
	validates :content, presence: true
	validates :content, length: { maximum: 140 }

	def self.posts_for(user)
		#author_user_ids = user.author_users.map { |usr| usr.id }
		#author_user_ids = user.author_users.map(&:id)
		author_user_ids = user.author_user_ids
		where("user_id IN (?) OR user_id = ?", author_user_ids, user)
	end
end
