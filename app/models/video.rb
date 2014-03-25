class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items
  has_many :users, through: :queue_items

  default_scope { order("created_at") }

  validates_presence_of :title, :description

  def self.search_by_title(keyword)
    return [] if keyword.blank?
    where("title LIKE ?", "%#{keyword}%")
  end
end
