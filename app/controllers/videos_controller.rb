class VideosController < ApplicationController
  before_filter :user_required!

  def index
    @category_videos = {}
    Category.all.each do |category|
      @category_videos.merge!(category => category.recent_videos)
    end
  end

  def show
    @video      = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews    = @video.reviews
    @new_review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:q])
  end

  def add_to_my_queue
    video = Video.find_by_id(params[:video_id])
    QueueItem.where(user: current_user, video: video).first_or_create(position: next_position)
    redirect_to my_queue_path
  end

  protected

  # FIXME: refactoring
  def next_position
    current_user.queue_items.maximum("position").to_i + 1
  end
end
