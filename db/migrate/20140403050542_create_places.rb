class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title
      t.integer :user_id
      t.string :address
      t.string :city
      t.string :place_type

      t.timestamps
    end
  end
end
