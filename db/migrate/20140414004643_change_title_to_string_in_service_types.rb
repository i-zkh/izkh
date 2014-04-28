class ChangeTitleToStringInServiceTypes < ActiveRecord::Migration
  def change
    change_column :service_types, :title, :string
  end
end
