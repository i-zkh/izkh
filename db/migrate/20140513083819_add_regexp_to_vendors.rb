class AddRegexpToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :regexp, :string
  end
end
