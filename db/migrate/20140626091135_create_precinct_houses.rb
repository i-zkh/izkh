class CreatePrecinctHouses < ActiveRecord::Migration
  def change
    create_table :precinct_houses do |t|
      t.integer :precinct_street_id
      t.integer :precinct_id
      t.string :house
    end
  end
end
