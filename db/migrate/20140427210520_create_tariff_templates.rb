class CreateTariffTemplates < ActiveRecord::Migration
  def change
    create_table :tariff_templates do |t|
      t.string :title
      t.integer :service_type_id
      t.boolean :has_reading
      t.integer :vendor_id

      t.timestamps
    end
  end
end
