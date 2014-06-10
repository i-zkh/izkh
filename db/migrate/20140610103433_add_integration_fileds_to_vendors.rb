class AddIntegrationFiledsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :filter, :boolean
    add_column :vendors, :billing, :boolean
  end
end
