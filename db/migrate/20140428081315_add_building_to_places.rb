class AddBuildingToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :building, :string
  end
end
