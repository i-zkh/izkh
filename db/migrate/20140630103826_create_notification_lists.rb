class CreateNotificationLists < ActiveRecord::Migration
  def change
    create_table :notification_lists do |t|
      t.integer :notification_id
      t.integer :user_id
      t.boolean :read

      t.timestamps
    end
  end
end
