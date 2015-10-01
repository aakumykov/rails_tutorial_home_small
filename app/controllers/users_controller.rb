class UsersController < ApplicationController

  # страница регистрации пользователя
  def new
  	@user = User.new
  end

  # список пользователей
  def index
  end

  # профиль пользователя
  def show
  	@user = User.find(params[:id])
  end

  # создание пользователя
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end


  private
    
    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
