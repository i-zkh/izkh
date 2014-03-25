class AddUserFields < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
    add_column :users, :phone, :string
    add_column :users, :gender, :string
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :city, :string
  end
end
