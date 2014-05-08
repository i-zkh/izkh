class RenameTypeInMeters < ActiveRecord::Migration
  def change
    rename_column :meters, :type, :meter_type
  end
end
