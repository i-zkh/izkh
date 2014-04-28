class WebMoney

  def self.invoice_confirmation(merchant_id, payment_amount, order_id)
    true_merchant_id = "6c2aa990-60e1-427f-9c45-75cffae4a745"
    transaction = Transaction.find_by_order_id(order_id)
    if (transaction.amount + transaction.commission) == payment_amount.to_i && merchant_id == true_merchant_id
      text = "YES"
    else
      text = "NO"
    end
    text
  end
end