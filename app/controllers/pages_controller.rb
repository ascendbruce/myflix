class PagesController < ApplicationController
  def front
    redirect_to home_path if signed_in?
  end

  def my_queue
  end
end
