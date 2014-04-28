class TerminalMigrations < ActiveRecord::Migration
  def change
    create_table :tariff_templates do |t|
      t.string :title
      t.integer :service_type_id
      t.boolean :has_reading
      t.integer :vendor_id

      t.timestamps
    end

    create_table :terminal_payments do |t|
      t.float :total
      t.float :amount
      t.float :commission
      t.string :user_account
      t.integer :vendor_id
      t.integer :tariff_template_id

      t.timestamps
    end
    
  end
end
