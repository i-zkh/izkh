class AddTariffTemplateIdToService < ActiveRecord::Migration
  def change
    add_column :services, :tariff_template_id, :integer
  end
end
