class SessionsController < ApplicationController
	
	# страница входа (создания новой сессии)
	def new
	end

	# создание сессии
	def create
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
	    # Sign the user in and redirect to the user's show page.
	  else
	    flash.now[:error] = 'Неверная комбинация логин/пароль'
	    render 'new'
	  end
	end

	# удаление сессии
	def destroy
	end

end
