class RelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		@author = User.find(params[:relationship][:author_id])
		current_user.read!(@author)
		respond_to do |format|
			format.html { redirect_to @author }
			format.js
		end
	end

	def destroy
		@author = Relationship.find(params[:id]).author
		# вариант
		# @author = current_user.relationships.find_by(id: params[:id]).author
		current_user.unread!(@author)
		respond_to do |format|
			format.html { redirect_to @author }
			format.js
		end
	end
end
