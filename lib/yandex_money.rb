class YandexMoney
  
  def initialize(requestDatetime, md5, orderSumCurrencyPaycash, orderSumBankPaycash, orderNumber, customerNumber, orderSumAmount, invoiceId)
    @requestDatetime = requestDatetime
    @md5 = md5
    @orderNumber = orderNumber.to_i
    @customerNumber = customerNumber.to_i
    @orderSumAmount = orderSumAmount.to_f
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
      commission = Vendor.where(title: transaction.payment_info.split(';')[1]).first.commission_yandex.to_f
      if transaction
        amount = (@orderSumAmount.to_f*100/(commission+100)).round(2)
        transaction.update_attributes(amount: amount, commission: @orderSumAmount.to_f - amount)
        @code = 0
      else
        @code = 100
      end
    else
      @code = 0
    end
    { performedDatetime: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000+04:00"), code: @code, invoiceId: @invoiceId, shopId: @shopId }
  end

  def notify
    if check_md5('paymentAviso')
      Transaction.find_by_order_id(@orderNumber).update_attribute(:status, 1)
      @code = 0
    else
      @code = 1
    end
    { performedDatetime: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000+04:00"), code: @code, invoiceId: @invoiceId, shopId: @shopId }
  end

  private

  def check_md5(action)
    require 'digest/md5'
    @md5.downcase == Digest::MD5.hexdigest("#{action};#{@orderSumAmount};#{@orderSumCurrencyPaycash};#{@orderSumBankPaycash};#{@shopId};#{@invoiceId};#{@customerNumber};#{@shopPassword}")
    @md5_own = Digest::MD5.hexdigest("#{action};#{@orderSumAmount};#{@orderSumCurrencyPaycash};#{@orderSumBankPaycash};#{@shopId};#{@invoiceId};#{@customerNumber};#{@shopPassword}")
  end
end