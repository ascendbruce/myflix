class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.references :video
      t.references :user
      t.integer :position

      t.timestamps
    end
  end
end
