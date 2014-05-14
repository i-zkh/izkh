class AddVendorIdToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :vendor_id, :integer
  end
end
