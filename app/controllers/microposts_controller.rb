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
		@micropost = Micropost.find_by(id: params[:id])
		@micropost_content = @micropost.content

		if @micropost.user == current_user
		 	if @micropost.destroy
		 		flash[:success] = "Сообщение '#{@micropost_content}' удалено"
		 	else
		 		flash[:error] = 'Ошибка удаления сообщения'
		 	end
		else
		 	flash[:error] = 'Нельзя удалить чужое сообщение'
		end

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
