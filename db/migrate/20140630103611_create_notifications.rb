class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :vendor_id
      t.string :notification_text

      t.timestamps
    end
  end
end
