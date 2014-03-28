class QueueItemsController < ApplicationController
  before_filter :user_required!

  def update_my_queue
    ordered_queue_item_ids = params[:position].sort_by { |_, v| v.to_i }.map { |k, _| k }
    ordered_queue_item_ids.each_with_index do |queue_item_id, index|
      queue_item = current_user.queue_items.find_by_id(queue_item_id)
      next if queue_item.nil?
      queue_item.position = index + 1
      queue_item.save
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
end
