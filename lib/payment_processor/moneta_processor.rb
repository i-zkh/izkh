require 'digest/md5'
class MonetaProcessor < PaymentProcessor

  CURRENCY    = 'RUB'
  TEST = 1
  MNT_SUBSCRIBER_ID = ''
  KEY = 'FiMsto33bl8ok'
  PAY_URL     = "http://moneta.ru/assistant.htm?MNT_CURRENCY_CODE=#{CURRENCY}"
  
  def initialize(total, user_account, order_id, service_type_id, name, phone, uin, id)
    @total = total
    @user_account = user_account
    @order_id = order_id
    @service_type_id = service_type_id
    @name = name 
    @phone = phone
    @uin = uin
    @id = id
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
    mnt_id = Vendor.find(@id).shop_article_id
    params = "MNT_ID=#{mnt_id}&MNT_TRANSACTION_ID=#{@order_id}&MNT_AMOUNT=#{@total}&MNT_SIGNATURE=#{generate_security_key(mnt_id)}"
    params =  if @service_type_id == 9
                [params, "CUSTOMFIELD:105=#{@uin}&CUSTOMFIELD:PHONE=#{@phone}&CUSTOMFIELD:FIO=#{@name}"].join('&')
              else 
                [params, "CUSTOMFIELD:100=#{@user_account}"].join('&')
              end
    p params
  end

  def generate_security_key(id)
    Digest::MD5.hexdigest("#{id}#{@order_id}#{@total}#{CURRENCY}#{MNT_SUBSCRIBER_ID}#{TEST}#{KEY}") 
  end
end