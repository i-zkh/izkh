#encoding: utf-8
class TransactionsController < ApplicationController
  skip_before_filter :require_current_user
  skip_before_action :verify_authenticity_token
  before_filter :prepare_payment_data, only: [:pay_new]

  def index
    @places = current_user.places.order("created_at desc")
  end

  def table_show
    @month_data = {}
    @services_data = []
    prev = Date.today.month - 1
    curr = Date.today.month
    nxt = Date.today.month + 1
    year = Date.today.year

    @month_data[:prev_month] = I18n.t('date.month_names')[prev]
    @month_data[:curr_month] = I18n.t('date.month_names')[curr]
    @month_data[:next_month] = I18n.t('date.month_names')[nxt]
    @month_data[:prev_month_sum] = 0
    @month_data[:curr_month_sum] = 0
    @month_data[:next_month_sum] = 0

    place = Place.find(params[:id])

    prev_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and place = ? and status = 1', prev, year, place.id.to_s)
    prev_trans.each do |pt|
      @month_data[:prev_month_sum] += pt.amount
    end

    curr_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and place = ? and status = 1', curr, year, place.id.to_s)
    curr_trans.each do |ct|
      @month_data[:curr_month_sum] += ct.amount
    end

    @month_data[:prev_month_sum] += (@month_data[:curr_month_sum] + @month_data[:prev_month_sum]) / 2
    
    services = place.services

    services.each do |service|
      prev_service_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and service = ? and status = 1', prev, year, service.id.to_s)
      curr_service_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and service = ? and status = 1', curr, year, service.id.to_s)
      
      prev_sum = 0
      curr_sum = 0
      next_sum = 0

      prev_service_trans.each {|st| prev_sum += st.amount}
      curr_service_trans.each {|ct| curr_sum += ct.amount}
      next_sum += (prev_sum + curr_sum) / 2
      @services_data << {title: service.title, prev_sum: prev_sum, curr_sum: curr_sum, next_sum: next_sum}
    end
    render partial: 'shared/transactions/services/index', status: :ok 
  end

  def graph_show
    @month_data = {}
    @data = []
    ykeys = []
    labels = []
    prev = Date.today.month - 2
    curr = Date.today.month - 1
    nxt = Date.today.month
    year = Date.today.year

    @month_data[:prev_month] = I18n.t('date.month_names')[prev]
    @month_data[:curr_month] = I18n.t('date.month_names')[curr]
    @month_data[:next_month] = I18n.t('date.month_names')[nxt]
    @month_data[:prev_month_sum] = 0
    @month_data[:curr_month_sum] = 0
    @month_data[:next_month_sum] = 0

    place = Place.find(params[:id])

    prev_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and place = ? and status = 1', prev, year, place.id.to_s)
    prev_trans.each do |pt|
      @month_data[:prev_month_sum] += pt.amount
    end

    curr_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and place = ? and status = 1', curr, year, place.id.to_s)
    curr_trans.each do |ct|
      @month_data[:curr_month_sum] += ct.amount
    end

    @month_data[:prev_month_sum] += (@month_data[:curr_month_sum] + @month_data[:prev_month_sum]) / 2
    @data_prev = {"m" => Date.today - 2.month}
    @data_curr = {"m" => Date.today - 1.month}
    @data_next = {"m" => Date.today}
    
    services = place.services
    services.each do |service|

      prev_service_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and service = ? and status = 1', prev, year, service.id.to_s)
      curr_service_trans = current_user.transactions.where('extract(month from created_at) = ? and extract(year from created_at) = ? and service = ? and status = 1', curr, year, service.id.to_s)
      
      prev_sum = 0
      curr_sum = 0
      next_sum = 0

      prev_service_trans.each {|st| prev_sum += st.amount}
      curr_service_trans.each {|ct| curr_sum += ct.amount}
      next_sum += (prev_sum + curr_sum) / 2
      @data_prev["#{service.id}"], @data_curr["#{service.id}"], @data_next["#{service.id}"] = prev_sum, curr_sum, next_sum
      labels << service.title
      ykeys << service.id.to_s
    end
    @service_data = {element: 'graph', xkey: 'm', ykeys: ykeys, labels: labels, data: [@data_prev, @data_curr, @data_next]}
    render json: @service_data, status: :ok
  end

  def pay_new
    Transaction.create!(@payment_data)
    case @payment_data[:payment_type].to_i
    when 2
      processor = YandexProcessor.new(@total, @user_id, @order_id, @shop_article_id, :money)
    when 3
      processor = YandexProcessor.new(@total, @user_id, @order_id, @shop_article_id, :card)
    else
      processor = PayOnlineProcessor.new(@total, @user_id, @order_id)
    end

    pp = PaymentProcessor.new(processor)

    respond_to do |format|
      format.js {
        render js: "window.location.replace('#{pp.pay}');"
      }
    end
  end

  def pay
    order_id = Time.now.strftime('%Y%M%d%H%M%S')
    amount = params[:pay][:amount]
    user_id = current_user.nil? ? 0 : current_user.id
    payment_type = params[:pay][:payment_type].nil? ? 1 : params[:pay][:payment_type].to_i
    key = params[:key].nil? ? "" : ";" + params[:key]
    if params[:pay][:service_id]
      service = Service.find(params[:pay][:service_id].to_i)
      vendor = Vendor.find(service.vendor_id) 
      place =  service.place
      place_id =  place.id
      service_type = service.service_type.title
      address = "#{place.city} #{place.address} #{place.building}, #{place.apartment}"
    else
      place_id, service, address, service_type = "", "", "", ""
      service_type = ServiceType.find(params[:service_type_id]).title if params[:service_type_id]
      vendor = Vendor.find(params[:vendor_id])
    end

    if payment_type == 2
      commission = vendor.commission_yandex
      total = calculate_total(amount, commission)
      url = "http://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196&Sum=#{total}&CustomerNumber=#{user_id}&orderNumber=#{order_id}&shopArticleId=#{vendor.shop_article_id}"
    elsif payment_type == 3
      commission = vendor.commission_ya_card
      total = calculate_total(amount, commission)
      url = "http://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196&Sum=#{total}&CustomerNumber=#{user_id}&orderNumber=#{order_id}&shopArticleId=#{vendor.shop_article_id}&paymentType=AC"
    elsif payment_type == 6
      commission = vendor.commission_web_money
      total = calculate_total(amount, commission)
      url = "http://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196&Sum=#{total}&CustomerNumber=#{user_id}&orderNumber=#{order_id}&shopArticleId=#{vendor.shop_article_id}&paymentType=WM"
    elsif payment_type == 4
      commission = vendor.commission_ya_cash_in
      total = calculate_total(amount, commission)
      url = "http://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196&Sum=#{total}&CustomerNumber=#{user_id}&orderNumber=#{order_id}&shopArticleId=#{vendor.shop_article_id}&paymentType=MC"
    elsif payment_type == 7
      commission = vendor.commission_ya_cash_in
      total = calculate_total(amount, commission)
      url = "http://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196&Sum=#{total}&CustomerNumber=#{user_id}&orderNumber=#{order_id}&shopArticleId=#{vendor.shop_article_id}&paymentType=SB"
    else
      currency = "RUB"
      merchant_id = '39859'
      commission = vendor.commission
      total = calculate_total(amount, commission)
      private_security_key = '7ab9d14e-fb6b-4c78-88c2-002174a8cd88'
      po_root_url = "https://secure.payonlinesystem.com/ru/payment/"
      security_key_string ="MerchantId=#{merchant_id}&OrderId=#{order_id}&Amount=#{total}&Currency=#{currency}&PrivateSecurityKey=#{private_security_key}"
      security_key = Digest::MD5.hexdigest(security_key_string)
      url = "#{po_root_url}?MerchantId=#{merchant_id}&OrderId=#{order_id}&Amount=#{total}&Currency=#{currency}&SecurityKey=#{security_key}&user_id=#{params[:pay][:user_id]}&ReturnURL=http%3A//localhost:8080/dashboard"
    end
    Transaction.create!(amount: amount.to_f, service: service, place: place_id, user_id: user_id, commission: (total.to_f-amount.to_f).round(2), payment_type: payment_type, payment_info: "#{payment_type};#{params[:user_account]};#{address};#{amount};#{(total.to_f-amount.to_f).round(2)};#{vendor.title};#{service_type};#{Time.now.strftime('%d.%m.%Y')}#{key}", order_id: order_id, vendor_id: vendor.id)

    respond_to do |format|
      format.js {
         render js: "window.location.replace('#{url}');"
      }
    end
  end

  def success
    # Callback for successful transactions PO
    transaction = Transaction.find_by_order_id(params[:OrderId].to_i)
    transaction.update_attribute(:status, 1)
    vendor_id = transaction.vendor_id
    amount = transaction.amount
    user_account = transaction.payment_info.split(';')[1]
    if vendor_id == 121
      GtPaymentWorker.perform_async(params[:OrderId].to_i, amount, user_account)
    #elsif service && service.vendor_id.to_i == 16
      #JtPaymentWorker.perform_async(params[:user_id])
    elsif vendor_id == 135
      SlPaymentWorker.perform_async(params[:OrderId].to_i, amount, user_account) 
    elsif vendor_id == 165
      CraftSPaymentWorker.perform_async(params[:OrderId].to_i, amount, user_account)
    elsif vendor_id == 20
      DeltaPaymentWorker.perform_async(transaction.payment_info.split(';')[-1])
    end
    render json: {}, status: :ok
  end

  #MONETA
  def pay_success
    transaction = Transaction.find_by_order_id(params[:MNT_TRANSACTION_ID].to_i)
    if transaction
      transaction.update_attribute(:status, 1)
      vendor_id = transaction.vendor_id
      amount = transaction.amount
      user_account = transaction.payment_info.split(';')[1]
      # if vendor_id == 121
      #   GtPaymentWorker.perform_async(params[:OrderId].to_i, amount, user_account)
      # #elsif service && service.vendor_id.to_i == 16
      #   #JtPaymentWorker.perform_async(params[:user_id])
      # elsif vendor_id == 135
      #   SlPaymentWorker.perform_async(params[:OrderId].to_i, amount, user_account) 
      # elsif vendor_id == 165
      #   CraftSPaymentWorker.perform_async(params[:OrderId].to_i, amount, user_account)
      # elsif vendor_id == 20
      #   DeltaPaymentWorker.perform_async(transaction.payment_info.split(';')[-1])
      # end
      logger.info transaction
      render text: 'SUCCESS'
    else
      render text: 'FAIL'
    end
  end

  def pay_fail
    Transaction.find_by_order_id(params[:MNT_TRANSACTION_ID].to_i).update_attribute(:status, -1)
    redirect_to dashboard_index_path
  end

  def fail
    # Callback for failed transactions PO
    Transaction.find_by_order_id(params[:OrderId].to_i).update_attribute(:status, -1)
    render json: {}, status: :ok
  end

  def check
    # CheckOrder for Yandex payment
    @check = YandexMoney.new(params[:requestDatetime], params[:md5], params[:orderSumCurrencyPaycash], params[:orderSumBankPaycash], params[:orderNumber], params[:customerNumber], params[:orderSumAmount], params[:invoiceId], params[:paymentType], params[:shopSumAmount], params[:shopArticleId]).check
    logger.info @check
    render :template => "yandex_money/check.xml.erb", :layout => false 
  end

  def notify
    @notify = YandexMoney.new(params[:requestDatetime], params[:md5], params[:orderSumCurrencyPaycash], params[:orderSumBankPaycash], params[:orderNumber], params[:customerNumber], params[:orderSumAmount], params[:invoiceId], params[:paymentType], params[:shopSumAmount], params[:shopArticleId]).notify
    logger.info @notify
    render :template => "yandex_money/notify.xml.erb", :layout => false
  end
    # Callback for successful transactions Yandex
  def invoice_confirmation
    # Invoice Confirmation for WebMoney
    render text: WebMoney.invoice_confirmation(params[:LMI_MERCHANT_ID], params[:LMI_PAYMENT_AMOUNT], params[:ORDER_ID])
  end

  def payment_notification
    # Callback for successful transactions WebMoney
    Transaction.find_by_order_id(params[:ORDER_ID].to_i).update_attribute(:status, 1)
    render text: "YES"
  end

  def failed_payment
    # Callback for failed transactions WebMoney
    Transaction.find_by_order_id(params[:ORDER_ID].to_i).update_attribute(:status, -1)
    redirect_to root_path
  end

  protected

  def prepare_payment_data

    if params[:pay][:service_id]
      service = Service.find(params[:pay][:service_id].to_i)
      place =  service.place
      place_id =  place.id
      service_type = service.service_type.title
      address = "#{place.city} #{place.address} #{place.building}, #{place.apartment}"
    else
      place_id, service, address, service_type = "", "", "", ""
      service_type = ServiceType.find(params[:service_type_id]).title if params[:service_type_id]
    end

    amount = params[:pay][:amount].to_f
    @vendor = Vendor.find(params[:pay][:vendor_id])
    @order_id = Time.now.strftime('%Y%M%d%H%M%S')
    @user_id = current_user.nil? ? 0 : current_user.id
    @payment_type = params[:pay][:payment_type].nil? ? 1 : params[:pay][:payment_type].to_i
    @shop_article_id = @vendor.shop_article_id
    key = params[:key].nil? ? "" : params[:key]
    date = Time.now.strftime('%d.%m.%y')
    commission = get_commission(@payment_type, @vendor)
    @total = calculate_total(amount, commission)
    payment_info = [@payment_type, params[:user_account], address, amount, commission, @vendor.title, service_type, date, key].join(';')

    @payment_data = { 
      amount: amount, 
      service: service, 
      place: place_id, 
      user_id: @user_id, 
      commission: commission, 
      payment_type: @payment_type, 
      payment_info: payment_info, 
      order_id: @order_id, 
      vendor_id: @vendor.id
    }

  end

  def get_commission(payment_type, vendor)
    commission =  if payment_type == 2
                    vendor.commission_yandex
                  elsif payment_type == 3
                    vendor.commission_ya_card
                  elsif payment_type == 4
                    vendor.commission_web_money
                  else
                    vendor.commission
                  end
  end

  def calculate_total(amount, commission)
    sprintf('%.2f', ((amount.to_f*(commission + 100))/100).round(2))
  end

  def transaction_params
    request.get? ? {} : params.require(:pay).permit(:amount, :commission, :error, :status, :user_id, :service_id, :place_id, :multiple, :included_transactions, :payment_type, :order_id)
  end
end