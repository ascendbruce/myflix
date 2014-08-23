class Admin::VideosController < Admin::ApplicationController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.title}'"
      redirect_to new_admin_video_path
    else
      flash[:error] = "you cannot add this video. Please check the errors."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:category_id, :title, :description, :small_cover, :large_cover)
  end
end
