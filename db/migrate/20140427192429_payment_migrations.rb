class PaymentMigrations < ActiveRecord::Migration
  def change
    add_column :vendors, :commission_yandex, :float
    add_column :vendors, :commission_web_money, :float

    add_column :transactions, :payment_type, :integer, default: 1
    add_column :transactions, :order_id, :bigint
  end
end
