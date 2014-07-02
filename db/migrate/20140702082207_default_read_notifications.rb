class DefaultReadNotifications < ActiveRecord::Migration
  def change
    change_column :notification_lists, :read, :boolean, default: false
  end
end
