class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.string :title
      t.integer :tariff_template_id
      t.integer :owner_id
      t.string :owner_type
      t.boolean :has_readings
      t.integer :service_type_id
      t.integer :service_id

      t.timestamps
    end
  end
end
