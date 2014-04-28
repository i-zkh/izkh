class AddCommissionsToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :commission_yandex, :float
    add_column :vendors, :commission_web_money, :float
  end
end
