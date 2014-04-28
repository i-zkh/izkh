class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :title
      t.integer :service_type_id
      t.boolean :send_metrics, default: false
      t.float :commission

      t.timestamps
    end
  end
end
