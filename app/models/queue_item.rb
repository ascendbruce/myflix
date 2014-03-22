class QueueItem < ActiveRecord::Base
  validates_presence_of :user_id, :video_id, :position

  belongs_to :user
  belongs_to :video

  default_scope { order("position ASC") }

  def rating
    review = Review.where(user: user, video: video).first
    review && review.rating
  end
end
