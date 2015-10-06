class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

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

  # страница редактирования
  def edit
    # @user теперь устанавливается в correct_user()
  end

  # обновление данных пользователя
  def update
    # @user теперь устанавливается в correct_user()
    if @user.update_attributes(user_params)
      flash[:success] = 'Данные пользователя изменены'
      redirect_to @user
    else
      render 'edit'
    end
  end


  private
    
    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: 'Пожалуйста, войдите.'
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url, alert: 'Нельзя редактировать чужой профиль.' unless current_user?(@user)
    end
end
