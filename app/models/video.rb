require Rails.root.join("app", "uploaders", "large_cover_uploader.rb")
require Rails.root.join("app", "uploaders", "small_cover_uploader.rb")

class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items
  has_many :users, through: :queue_items

  default_scope { order("created_at") }

  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(keyword)
    return [] if keyword.blank?
    where("title LIKE ?", "%#{keyword}%")
  end
end
