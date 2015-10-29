class RelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		@user = User.find(params[:relationship][:author_id])
		current_user.read!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).author
		# вариант
		# @user = current_user.relationships.find_by(id: params[:id]).author
		current_user.unread!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end
