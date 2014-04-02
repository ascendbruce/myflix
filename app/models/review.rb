class Review < ActiveRecord::Base
  validates_presence_of     :user_id, :video_id, :rating
  validates_presence_of     :comment, unless: :skip_validates_presence_of_comment
  validates_numericality_of :rating

  belongs_to :user
  belongs_to :video

  attr_accessor :skip_validates_presence_of_comment
end
