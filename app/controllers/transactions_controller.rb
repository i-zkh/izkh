#encoding: utf-8
class TransactionsController < ApplicationController
  skip_before_filter :require_current_user

  def index
    @trans = current_user.transactions
    @places = current_user.places
    @summ = 0
    @trans.each do |t|
      @summ += t.amount.to_f
    end
  end

  def pay
    order_id = Time.now.strftime('%Y%M%d%H%M%S')
    amount = [params[:pay][:amount_1], params[:pay][:amount_2]].join('.')
    payment_type = params[:pay][:payment_type].nil? ? 1 : params[:pay][:payment_type].to_i
    service = Service.find(params[:pay][:service_id])
    if payment_type == 2
      commission = Vendor.find(service.vendor_id).commission_yandex
      total = calculate_total(amount, commission)
      url = "https://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196&Sum=#{total}&CustomerNumber=#{params[:pay][:user_id]}&orderNumber=#{order_id}"
    elsif payment_type == 3
      commission = Vendor.find(service.vendor_id).commission_web_money
      total = calculate_total(amount, commission)
      url = "https://paymaster.ru/Payment/Init?LMI_MERCHANT_ID=6c2aa990-60e1-427f-9c45-75cffae4a745&LMI_PAYMENT_AMOUNT=#{total}&LMI_PAYMENT_DESC=АйЖКХ&LMI_CURRENCY=RUB&ORDER_ID=#{order_id}"
    else
      currency = "RUB"
      merchant_id = '39859'
      commission = Vendor.find(service.vendor_id).commission
      total = calculate_total(amount, commission)
      private_security_key = '7ab9d14e-fb6b-4c78-88c2-002174a8cd88'
      po_root_url = "https://secure.payonlinesystem.com/ru/payment/"
      security_key_string ="MerchantId=#{merchant_id}&OrderId=#{order_id}&Amount=#{total}&Currency=#{currency}&PrivateSecurityKey=#{private_security_key}"
      security_key = Digest::MD5.hexdigest(security_key_string)
      url = "#{po_root_url}?MerchantId=#{merchant_id}&OrderId=#{order_id}&Amount=#{total}&Currency=#{currency}&SecurityKey=#{security_key}&user_id=#{params[:pay][:user_id]}&ReturnURL=http%3A//localhost:8080/dashboard"
    end
    Transaction.create!(amount: amount.to_f, service: Service.find(params[:pay][:service_id]).title, place: Place.find(service.place_id).title, user_id: current_user.id, commission: commission.to_f, payment_type: payment_type, order_id: order_id)

    respond_to do |format|
      format.js {
         render js: "window.location.replace('#{url}');"
      }
    end
  end

  def success
    # Callback for successful transactions PO
    Transaction.find_by_order_id(params[:OrderId].to_i).update_attribute(:status, 1)
  end

  def fail
    # Callback for failed transactions PO
    Transaction.find_by_order_id(params[:OrderId].to_i).update_attribute(:status, -1)
  end

  def check
    # CheckOrder for Yandex payment
    @check = YandexMoney.new(params[:requestDatetime], params[:md5], params[:orderSumCurrencyPaycash], params[:orderSumBankPaycash], params[:orderNumber], params[:customerNumber], params[:orderSumAmount], params[:invoiceId]).check
    logger.info @check
    render :template => "yandex_money/check.xml.erb", :layout => false 
  end

  def notify
    # Callback for successful transactions Yandex
    @notify = YandexMoney.new(params[:requestDatetime], params[:md5], params[:orderSumCurrencyPaycash], params[:orderSumBankPaycash], params[:orderNumber], params[:customerNumber], params[:orderSumAmount], params[:invoiceId]).notify
    logger.info @notify
    render :template => "yandex_money/notify.xml.erb", :layout => false
  end

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

  def calculate_total(amount, commission)
    sprintf('%.2f', ((amount.to_f*(commission + 100))/100).round(2))
  end

  def transaction_params
    request.get? ? {} : params.require(:pay).permit(:amount_1, :amount_2, :commission, :error, :status, :user_id, :service_id, :place_id, :multiple, :included_transactions, :payment_type, :order_id)
  end
end
