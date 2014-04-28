class AddApartmentToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :apartment, :string
    add_column :users, :authentication_token, :string
  end
end
