class RemoveLargeCoverPathAndSmallCoverPathFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :large_cover_path, :string
    remove_column :videos, :small_cover_path, :string
  end
end
