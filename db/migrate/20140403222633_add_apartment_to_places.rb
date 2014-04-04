class AddApartmentToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :apartment, :string
  end
end
