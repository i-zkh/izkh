class AddServiceIdToMeters < ActiveRecord::Migration
  def change
    add_column :meters, :service_id, :integer
  end
end
