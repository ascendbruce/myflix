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
end
