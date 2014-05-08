class WigetsMigrations < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :title
      t.text :description
      t.string :sender

      t.timestamps
    end

    create_table :widgetables do |t|
      t.belongs_to :user
      t.belongs_to :widget
      t.boolean :status, default: false

      t.timestamps
    end
  end
end