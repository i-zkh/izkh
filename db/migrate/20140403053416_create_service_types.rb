class CreateServiceTypes < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.integer :title

      t.timestamps
    end
  end
end
