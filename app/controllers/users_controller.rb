class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :create_and_new, only: [:create, :new] # это не защищает от атаки незарегистрированным

  # страница регистрации пользователя
  def new
  	@user = User.new
  end

  # список пользователей
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  # профиль пользователя
  def show
  	@user = User.find_by(id: params[:id])
    if nil == @user
      flash[:alert] = 'Нет такого пользователя'
      redirect_to users_path
    else
      @microposts = @user.microposts.paginate(page: params[:page])
    end
  end

  # создание пользователя
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App, #{@user.name}!"
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

  # удаление пользователя
  def destroy
    user_to_delete = User.find(params[:id])
    if ( current_user == user_to_delete ) then
      flash[:notice] = 'Нельзя удалить себя самого!'
    else
      user_to_delete.destroy
      flash[:success] = "Пользователь \"#{user_to_delete.name}\" удалён."
    end
    redirect_to users_path
  end


  private
    
    def user_params
    	params.require(:user).permit(
        :name, 
        :email, 
        :password, 
        :password_confirmation,
      )
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url, alert: 'Нельзя редактировать чужой профиль.' unless current_user?(@user)
    end

    def admin_user
      redirect_to root_url if !current_user.admin?
    end

    def create_and_new
      #redirect_to root_url if ( params['authenticity_token'].nil? or params['authenticity_token'].blank? )
      redirect_to root_path if signed_in?
    end
end
