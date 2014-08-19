class Admin::VideosController < Admin::ApplicationController
  def new
    @video = Video.new
  end
end
