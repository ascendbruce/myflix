class RelationshipsController < ApplicationController
  before_filter :user_required!

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = current_user.following_relationships.find_by_id(params[:id])
    relationship.destroy if relationship
    redirect_to people_path
  end

  def create
    leader = User.find_by_id(params[:leader_id])
    if leader != current_user
      Relationship.where(follower: current_user, leader: leader).first_or_create
    end
    redirect_to people_path
  end
end
