class QueueItemsController < ApplicationController
  before_filter :user_required!

  def destroy
    queue_item = QueueItem.find_by_id(params[:id])
    if queue_item && queue_item.user == current_user
      queue_item.destroy
    end
    redirect_to my_queue_path
  end
end
