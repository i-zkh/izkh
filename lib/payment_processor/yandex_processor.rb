class YandexProcessor < PaymentProcessor

  PAY_URL = "http://money.yandex.ru/eshop.xml?scid=7072&shopId=15196"

  def initialize(total = nil, user_account = nil, order_id = nil, shop_article_id = nil, type = nil)
    @total = total
    @user_account = user_account
    @order_id = order_id
    @shop_article_id = shop_article_id
    @type = type
  end

  def pay
    [PAY_URL, request_params].join('&')
  end

  def check(params)
    yandex_params(params)
    if check_md5('checkOrder')
      transaction = Transaction.find_by_order_id(@order_id)
      transaction && transaction.amount == @shop_amount.to_f
      unless transaction && transaction.amount == @shop_amount.to_f
        vendor = Vendor.find_by_shop_article_id(@article_id.to_i)
        if vendor
          commission = (@order_amount.to_f - @shop_amount.to_f).round(2)
          Transaction.create!(amount: @shop_amount, service: "", place: "", user_id: 0, commission: commission, payment_type: @payment_type, payment_info: "#{@payment_type};#{@user_account};;#{@shop_amount};#{commission};#{vendor.title};;#{Time.now.strftime('%d.%m.%y')}", order_id: @order_id, vendor_id: vendor.id)
        else
          @code = 1000
        end
      end
    else
      @code = 1
    end
    { performedDatetime: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000+04:00"), code: @code, invoice_id: @invoice_id, shop_id: @shop_id }
  end

  def notify(params)
    yandex_params(params)
    if check_md5('paymentAviso')
      transaction = Transaction.find_by_order_id(@order_id)
      commission = commission_pay(transaction.payment_type, transaction.vendor_id)
      amount = ((@order_amount.to_f*100/(100+commission))*100).ceil/100.0
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
    { performedDatetime: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000+04:00"), code: @code, invoice_id: @invoice_id, shop_id: @shop_id }
  end

protected

  def yandex_params(params)
    @md5          = params[:md5]
    @order_id     = params[:orderNumber]
    @user_account = params[:customerNumber]
    @order_amount = format(params[:orderSumAmount])
    @sum_currency = params[:orderSumCurrencyPaycash]
    @sum_bank     = params[:orderSumBankPaycash]
    @invoice_id   = params[:invoiceId]
    @payment_type = get_payment_type(params[:paymentType])
    @shop_amount  = format(params[:shopSumAmount])
    @article_id   = params[:shopArticleId]
    @shop_id      = 15196
    @code         = 0
    @password     = "Sum0Zozilock8Qzhsoli"
  end

  def request_params
    params = "Sum=#{@total}&CustomerNumber=#{@user_account}&orderNumber=#{@order_id}&shopArticleId=#{@shop_article_id}"    
    params = [params, "paymentType=AC"].join('&') if @type == :card
    params = [params, "paymentType=WM"].join('&') if @type == :web_money
    params
  end

  def get_payment_type(payment_type)
    payment_types = {'AC' => 3, 'WM' => 6, 'PC' => 2}
    payment_types[payment_type]
  end

  def commission_pay(payment_type, vendor_id)
    if payment_type == 2
      Vendor.find(vendor_id).commission_ya_card
    elsif payment_type == 3
      Vendor.find(vendor_id).commission_yandex
    elsif payment_type == 6
      Vendor.find(vendor_id).commission_web_money
    elsif payment_type == 4 || payment_type == 7
      Vendor.find(vendor_id).commission_ya_cash_in
    end
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
    @md5.downcase == Digest::MD5.hexdigest("#{action};#{@order_amount};#{@sum_currency};#{@sum_bank};#{@shop_id};#{@invoice_id};#{@user_account};#{@password}")
  end

end