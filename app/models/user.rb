class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  has_many :reviews
  has_many :queue_items, -> { order "position ASC" }
  has_many :videos, through: :queue_items

  def queue_items_update_position_by(sorted_queue_item_ids)
    sorted_queue_item_ids.each_with_index do |queue_item_id, index|
      queue_item = queue_items.find_by_id(queue_item_id)
      queue_item.update_attributes(position: index + 1) if queue_item
    end
  end
end
