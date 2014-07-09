class PayOnlineProcessor < PaymentProcessor

  PAY_URL = "https://secure.payonlinesystem.com/ru/payment/"
  PSK = '7ab9d14e-fb6b-4c78-88c2-002174a8cd88'
  MID = '39859'
  
  def initialize(total, user_id, order_id)
    @order_id = order_id
    @total = total
    @user_id = user_id
  end

  def pay
    "#{PAY_URL}?MerchantId=#{MID}&OrderId=#{@order_id}&Amount=#{@total}&Currency=RUB&SecurityKey=#{generate_security_key}&user_id=#{@user_id}&ReturnURL=http%3A//izkh.ru/dashboard"
  end

  def success
  end

  def fail
  end

protected
  def generate_security_key
    Digest::MD5.hexdigest("MerchantId=#{MID}&OrderId=#{@order_id}&Amount=#{@total}&Currency=RUB&PrivateSecurityKey=#{PSK}")
  end
end