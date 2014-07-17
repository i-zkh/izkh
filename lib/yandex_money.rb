class YandexMoney
  
  def initialize(requestDatetime, md5, orderSumCurrencyPaycash, orderSumBankPaycash, orderNumber, customerNumber, orderSumAmount, invoiceId, paymentType, shopSumAmount, shopArticleId)
    @requestDatetime = requestDatetime
    @md5 = md5
    @orderNumber = orderNumber.to_i
    @customerNumber = customerNumber.to_i
    @orderSumAmount = format(orderSumAmount)
    @orderSumCurrencyPaycash = orderSumCurrencyPaycash
    @orderSumBankPaycash = orderSumBankPaycash
    @invoiceId = invoiceId
    @payment_type = get_payment_type(paymentType)
    @shopSumAmount = format(shopSumAmount)
    @shopArticleId = shopArticleId
    @shopId = 15196
    @code = 1000
    @shopPassword = "Sum0Zozilock8Qzhsoli"
  end
  
  def check
    if check_md5('checkOrder')
      transaction = Transaction.find_by_order_id(@orderNumber)
      if transaction
        @code = 0
      else
        vendor = Vendor.find_by_shop_article_id(@shopArticleId.to_i)
        commis = (@orderSumAmount.to_f - @shopSumAmount.to_f).round(2)
        transaction = Transaction.create!(amount: @shopSumAmount, service: "", place: "", user_id: 0, commission: commis, payment_type: @payment_type, payment_info: "#{@payment_type};#{@customerNumber};;#{@shopSumAmount};#{commis};#{vendor.title};;#{Time.now.strftime('%d.%m.%y')}", order_id: @orderNumber, vendor_id: vendor.id)
        @code = 0
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
                    elsif transaction.payment_type == 3
                      Vendor.find(transaction.vendor_id).commission_yandex
                    elsif transaction.payment_type == 6
                      Vendor.find(transaction.vendor_id).commission_web_money
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

  def get_payment_type(payment_type)
    payment_types = {'AC' => 3, 'WM' => 6, 'PC' => 2}
    payment_types[payment_type]
  end

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