class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :meter_id
      t.float :metric
      t.integer :status

      t.timestamps
    end
  end
end
