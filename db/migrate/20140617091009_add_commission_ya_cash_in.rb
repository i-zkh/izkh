class AddCommissionYaCashIn < ActiveRecord::Migration
  def change
    add_column :vendors, :commission_ya_cash_in, :float
  end
end
