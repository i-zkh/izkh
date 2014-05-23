class AddCommisionToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :commission_ya_card, :float
  end
end
