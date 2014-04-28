class CreateWidgetables < ActiveRecord::Migration
  def change
    create_table :widgetables do |t|
      t.belongs_to :user
      t.belongs_to :widget
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
