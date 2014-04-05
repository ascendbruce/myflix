module VideosHelper
  def add_to_my_queue_link
    link_to "+ My Queue", add_to_my_queue_videos_path(video_id: @video.id), class: "btn ben-default", method: :post
  end
end
