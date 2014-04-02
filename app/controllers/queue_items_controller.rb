class QueueItemsController < ApplicationController
  before_filter :user_required!

  def update_my_queue
    current_user.queue_items_update_position_by(sorted_queue_item_ids)

    if params[:rating].present?
      params[:rating].each do |queue_item_id, rating|
        queue_item = QueueItem.find_by_id(queue_item_id)
        review = Review.where(user: current_user, video: queue_item.video).first_or_create
        review.update_attributes(skip_validates_presence_of_comment: true, rating: rating)
      end
    end

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by_id(params[:id])
    if queue_item && queue_item.user == current_user
      queue_item.destroy
    end
    redirect_to my_queue_path
  end

  protected

  # returns an array of queue_item.id, sorted by user's input
  def sorted_queue_item_ids
    params[:position].sort_by { |_, v| v.to_i }.map { |k, _| k }
  end
end
