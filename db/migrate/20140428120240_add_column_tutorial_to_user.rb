class AddColumnTutorialToUser < ActiveRecord::Migration
  def change
    add_column :users, :tutorial, :boolean, default: true
  end
end
