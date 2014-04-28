class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :amount
      t.float :commission
      t.integer :status, default: 0
      t.text :error
      t.string :place
      t.string :service
      t.integer :user_id
      t.boolean :multiple
      t.integer :included_transactions, array: true, default: []

      t.timestamps
    end
  end
end
