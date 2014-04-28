class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :title
      t.text :description
      t.string :sender

      t.timestamps
    end
  end
end
