class StaticPagesController < ApplicationController
  def home
	if signed_in?
  		@user = current_user
  		@micropost = current_user.microposts.build
  	end
  end

  def help
  end

  def about
  end
end
