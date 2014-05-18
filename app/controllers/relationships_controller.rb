class RelationshipsController < ApplicationController
  before_filter :user_required!

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find_by_id(params[:leader_id])
    current_user.follow(leader) if leader
    redirect_to people_path
  end

  def destroy
    current_user.unfollow_by_relationship_id(params[:id])
    redirect_to people_path
  end
end
