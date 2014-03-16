class QueueItem < ActiveRecord::Base
  validates_presence_of :user_id, :video_id, :position

  belongs_to :user
  belongs_to :video
end
