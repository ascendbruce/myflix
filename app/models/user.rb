class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  has_many :reviews
  has_many :queue_items, -> { order "position ASC" }
  has_many :videos, through: :queue_items

  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships,   class_name: "Relationship", foreign_key: :leader_id

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

  def queued_video?(video)
    # without `reorder("id")` here will cause following error:
    #   ActiveRecord::StatementInvalid: SQLite3::SQLException: ambiguous column name: created_at: SELECT  1 AS one FROM "videos" INNER JOIN "queue_items" ON "videos"."id" = "queue_items"."video_id" WHERE "queue_items"."user_id" = ? AND "videos"."id" = 1  ORDER BY created_at LIMIT 1
    videos.where( videos: { id: video.id } ).reorder("id").exists?
  end

  def can_follow?(another_user)
    !(follows?(another_user) || self == another_user)
  end

  def follows?(another_user)
    Relationship.where(follower: self, leader: another_user).exists?
  end

  def follow(leader)
    return unless can_follow?(leader)
    Relationship.where(follower: self, leader: leader).first_or_create
  end

  def unfollow_by_relationship_id(relationship_id)
    relationship = following_relationships.find_by_id(relationship_id)
    relationship.destroy if relationship
  end

  def generate_token
    self.update_attribute(:token, SecureRandom.urlsafe_base64)
  end

end
