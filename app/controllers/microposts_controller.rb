class MicropostsController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user, only: [:destroy]

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Микросообщение создано!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		@message_content = @micropost.content
		flash[:success] = "Сообщение '#{@message_content}' удалено"
		redirect_back_or current_user
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_back_or current_user if @micropost.nil?
		end
end