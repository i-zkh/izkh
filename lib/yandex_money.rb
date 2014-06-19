class YandexMoney
  
  def initialize(requestDatetime, md5, orderSumCurrencyPaycash, orderSumBankPaycash, orderNumber, customerNumber, orderSumAmount, invoiceId)
    @requestDatetime = requestDatetime
    @md5 = md5
    @orderNumber = orderNumber.to_i
    @customerNumber = customerNumber.to_i
    @orderSumAmount = format(orderSumAmount)
    @orderSumCurrencyPaycash = orderSumCurrencyPaycash
    @orderSumBankPaycash = orderSumBankPaycash
    @invoiceId = invoiceId
    @shopId = 15196
    @code = 1000
    @shopPassword = "Sum0Zozilock8Qzhsoli"
  end
  
  def check
    if check_md5('checkOrder')
      transaction = Transaction.find_by_order_id(@orderNumber)
      commission =  if transaction.payment_type == 2
                      Vendor.find(transaction.vendor_id).commission_ya_card
                    elsif transaction.payment_type == 3
                      Vendor.find(transaction.vendor_id).commission_yandex
                    elsif transaction.payment_type == 6
                      Vendor.find(transaction.vendor_id).commission_web_money
                    elsif transaction.payment_type == 4 || transaction.payment_type == 7
                      Vendor.find(transaction.vendor_id).commission_ya_cash_in
                    end
      if transaction
        amount = ((@orderSumAmount.to_f*100/(100+commission))*100).ceil/100.0
        transaction.update_attributes(amount: amount, commission: @orderSumAmount.to_f - amount)
        @code = 0
      else
        @code = 100
      end
    else
      @code = 1
    end
    { performedDatetime: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000+04:00"), code: @code, invoiceId: @invoiceId, shopId: @shopId }
  end

  def notify
    if check_md5('paymentAviso')
      transaction = Transaction.find_by_order_id(@orderNumber)
      commission =  if transaction.payment_type == 2
                      Vendor.find(transaction.vendor_id).commission_ya_card
                    elsif transaction.payment_type ==3
                      Vendor.find(transaction.vendor_id).commission_yandex
                    end
      amount = ((@orderSumAmount.to_f*100/(100+commission))*100).ceil/100.0
      user_account = transaction.payment_info.split(';')[1]
      vendor_id = transaction.vendor_id
      order_id = transaction.order_id

      transaction.update_attribute(:status, 1)
      
      if vendor_id == 121
        GtPaymentWorker.perform_async(order_id.to_i, amount, user_account)
      elsif vendor_id == 135
        SlPaymentWorker.perform_async(order_id.to_i, amount, user_account) 
      elsif vendor_id == 165
        CraftSPaymentWorker.perform_async(order_id.to_i, amount, user_account)
      elsif vendor_id == 20
        DeltaPaymentWorker.perform_async(transaction.payment_info.split(';')[-1])
      end
      @code = 0
    else
      @code = 1
    end
    { performedDatetime: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000+04:00"), code: @code, invoiceId: @invoiceId, shopId: @shopId }
  end

  def hash
    "checkOrder;#{@orderSumAmount};#{@orderSumCurrencyPaycash};#{@orderSumBankPaycash};#{@shopId};#{@invoiceId};#{@customerNumber};#{@shopPassword}"
  end

  def md5_hash
    require 'digest/md5'
    Digest::MD5.hexdigest("checkOrder;#{@orderSumAmount};#{@orderSumCurrencyPaycash};#{@orderSumBankPaycash};#{@shopId};#{@invoiceId};#{@customerNumber};#{@shopPassword}")
  end

  private

  def format(float)
    # Formats float value to 'xxx.xx', returns string
    float.to_s =~ /\d+.(\d+)/
    unless $1 =~ /\d\d/
      float = float.to_s + '0'
    end
    float.to_s
  end

  def check_md5(action)
    require 'digest/md5'
    @md5.downcase == Digest::MD5.hexdigest("#{action};#{@orderSumAmount};#{@orderSumCurrencyPaycash};#{@orderSumBankPaycash};#{@shopId};#{@invoiceId};#{@customerNumber};#{@shopPassword}")
  end
end