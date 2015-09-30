class SessionsController < ApplicationController
	
	# страница входа (создания новой сессии)
	def new
	end

	# создание сессии
	def create
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
	    sign_in user
	    redirect_to user
	    #redirect_to user_path(user.id)
	  else
	    flash.now[:error] = 'Неверная комбинация логин/пароль'
	    render 'new'
	  end
	end

	# удаление сессии
	def destroy
	end

end
