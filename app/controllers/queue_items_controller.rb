class QueueItemsController < ApplicationController
  before_filter :user_required!

  def update_my_queue
    current_user.queue_items_update_position_by(sorted_queue_item_ids)
    current_user.queue_items_update_rating_by(params[:rating])

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
