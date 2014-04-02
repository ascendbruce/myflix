class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  has_many :reviews
  has_many :queue_items, -> { order "position ASC" }
  has_many :videos, through: :queue_items

  def queue_items_update_position_by(sorted_queue_item_ids)
    return if sorted_queue_item_ids.blank?
    sorted_queue_item_ids.each_with_index do |queue_item_id, index|
      queue_item = queue_items.find_by_id(queue_item_id)
      queue_item.update_attributes(position: index + 1) if queue_item
    end
  end

  def queue_items_update_rating_by(queue_item_and_ratings)
    return if queue_item_and_ratings.blank?
    queue_item_and_ratings.each do |queue_item_id, rating|
      queue_item = queue_items.find_by_id(queue_item_id)

      if queue_item
        review = Review.where(user: self, video: queue_item.video).first_or_create
        review.update_attributes(skip_validates_presence_of_comment: true, rating: rating)
      end
    end
  end

end
