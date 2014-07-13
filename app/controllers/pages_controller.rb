class PagesController < ApplicationController
  before_filter :user_required!, except: [:front]

  def front
    redirect_to home_path if signed_in?
  end

  def my_queue
    @queue_items = current_user.queue_items.includes(video: [:category, :reviews] )
  end

  def expired_token
  end
end
