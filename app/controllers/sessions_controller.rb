class SessionsController < ApplicationController
	
	# страница входа пользователя
	def new
		#redirect_back_or root_url if signed_in?
		redirect_to root_url if signed_in?
	end

	# создание сессии
	def create
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
	    sign_in user
	    redirect_back_or user
	    #redirect_back_or user_path(user.id)
	  else
	    flash.now[:error] = 'Неверная комбинация логин/пароль'
	    render 'new'
	  end
	end

	# удаление сессии
	def destroy
		sign_out
		redirect_to root_url
	end

end
