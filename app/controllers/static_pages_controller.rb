class StaticPagesController < ApplicationController

  def home
	if signed_in?
  		@user = current_user
  		@micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
  	end
  end

  def help
  end

  def about
  end

end
