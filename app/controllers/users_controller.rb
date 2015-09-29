class UsersController < ApplicationController

  # new
  def new
  	@user = User.new
  end

  # index
  def index
  end

  # show
  def show
  	@user = User.find(params[:id])
  end

  # create
  def create
  	@user = User.new(user_params)    # Not the final implementation!

    if @user.save
      #redirect_to user_path(@user.id)
      redirect_to @user
    else
      render 'new'
    end
  end

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end












end
