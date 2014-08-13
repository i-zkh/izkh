require 'digest/md5'
class MonetaProcessor < PaymentProcessor

  IJKH_ID     = 50912255
  CURRENCY    = 'RUB'
  PENALTY_ID  = 93717170
  SERVICES_ID = 91552991
  TEST = 1
  MNT_SUBSCRIBER_ID = ''
  KEY = 'FiMsto33bl8ok'
  PAY_SYSTEM = { moneta: 123, card: 499669, web_money: 123 }
  PAY_URL     = "http://moneta.ru/assistant.htm?MNT_CURRENCY_CODE=#{CURRENCY}"
  
  def initialize(total, user_account, order_id, service_type_id)
    @total = total
    @user_account = user_account
    @order_id = order_id
    @service_type_id = service_type_id
  end

  def pay
    [PAY_URL, request_params].join('&')
  end

  def success
  end

  def fail
  end

protected

  def request_params
    params = "&MNT_TRANSACTION_ID=#{@order_id}&MNT_AMOUNT=#{@total}"
    params =  case @service_type_id
              when 4 then [params, "MNT_ID=#{IJKH_ID}&SUBPROVIDERID=2&CUSTOMFIELD:100=#{@user_account}&MNT_SIGNATURE=#{generate_security_key(IJKH_ID)}"].join('&')
              when 9 then [params, "MNT_ID=#{PENALTY_ID}&CUSTOMFIELD:105=#{@user_account}&CUSTOMFIELD:PHONE=123&CUSTOMFIELD:FIO=имя&MNT_SIGNATURE=#{generate_security_key(PENALTY_ID)}"].join('&')
              else 
                [params, "MNT_ID=#{SERVICES_ID}&SUBPROVIDERID=2&CUSTOMFIELD:100=#{@user_account}&MNT_SIGNATURE=#{generate_security_key(SERVICES_ID)}"].join('&')
              end
    params
  end

  def generate_security_key(id)
    Digest::MD5.hexdigest("#{id}#{@order_id}#{@total}#{CURRENCY}#{MNT_SUBSCRIBER_ID}#{TEST}#{KEY}") 
  end
end