class CreateMeters < ActiveRecord::Migration
  def change
    create_table :meters do |t|
      t.integer :user_id
      t.string :type
      t.integer :vendor_id

      t.timestamps
    end
  end
end
