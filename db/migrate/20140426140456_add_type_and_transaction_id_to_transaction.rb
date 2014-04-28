class AddTypeAndTransactionIdToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :payment_type, :integer, default: 1
    add_column :transactions, :order_id, :bigint
  end
end
