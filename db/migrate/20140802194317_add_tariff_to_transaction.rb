class AddTariffToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :tariff_template_id, :integer
  end
end
