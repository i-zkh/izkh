class CraftSProcessor < BillingProcessor

  URL = "https://billing.kraft-s.ru:47035/pays/izkh.php"

  def initialize(user_account, date, account_type, amount=nil, order_id=nil)
    @user_account = user_account
    @date = date
    @account_type = account_type
    @amount = amount.to_i
    @order_id = order_id
  end

  def check
    url = form_check_url
    er = ExternalRequest.new(URI.escape(url), true, nil, "izkh")
    parse_response(er.get)
  end

  def pay
    url = form_pay_url
    er = ExternalRequest.new(URI.escape(url), true, nil, "izkh")
    er.get
  end

protected
  def parse_response(response)
    response = Crack::XML.parse(response)
    if response["response"]["status"].to_s == "0"
      account_type = response["response"]["atype"] == "inet" ? "Интернет" : "Телефония"
      {user_account: response["response"]["account"], 
        account_type: account_type, 
        fio: response["response"]["fio"], 
        debt: response["response"]["debt"], 
        hot_debt: response["response"]["hot_debt"]}
    else
      nil
    end
  end

  def form_check_url
    "#{URL}?ID=#{DateTime.now.to_s(:number)}&DATE=#{@date}&TYPE=4&ATYPE=#{@account_type}&ACCOUNT=#{@user_account.to_s}&SUM=0"
  end

  def form_pay_url
    "#{URL}?ID=#{@order_id}&DATE=#{@date}&TYPE=1&ACCOUNT=#{@user_account.to_s}&ATYPE=#{@account_type}&SUM=#{@amount.to_s}"
  end

end