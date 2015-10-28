class RelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		@author = User.find(params[:relationship][:author_id])
		current_user.read!(@author)
		redirect_to @author
	end

	def destroy
		@author = Relationship.find(params[:id]).author
		# вариант
		# @author = current_user.relationships.find_by(id: params[:id]).author
		current_user.unread!(@author)
		redirect_to @author
	end
end
