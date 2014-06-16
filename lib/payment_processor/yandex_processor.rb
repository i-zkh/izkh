class YandexProcessor < PaymentProcessor

  PAY_URL = "http://money.yandex.ru/eshop.xml?scid=7072&ShopID=15196"

  def initialize(total, user_id, order_id, shop_article_id, type)
    @total = total
    @user_id = user_id
    @order_id = order_id
    @shop_article_id = shop_article_id
    @type = type
  end

  def pay
    [PAY_URL, request_params].join('&')
  end

  def success(params)
  end

  def fail(params)
  end

  def check(params)
  end

  def notify(params)
  end

protected

  def request_params
    params = "Sum=#{@total}&CustomerNumber=#{@user_id}&orderNumber=#{@order_id}&shopArticleId=#{@shop_article_id}"    
    params = [params, "paymentType=AC"].join('&') if @type == :card
    params
  end

end