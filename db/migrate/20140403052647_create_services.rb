class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :title
      t.integer :vendor_id
      t.integer :service_type_id
      t.string :user_account
      t.integer :place_id
      t.integer :user_id

      t.timestamps
    end
  end
end
