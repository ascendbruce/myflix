class Admin::ApplicationController < ApplicationController
  before_action :user_required!
  before_action :admin_required!

  def admin_required!
    unless current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to home_path
    end
  end
end
