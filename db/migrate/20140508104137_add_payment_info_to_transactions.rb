class AddPaymentInfoToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :payment_info, :string
  end
end
