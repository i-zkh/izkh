#encoding: utf-8
class MyBox
  def initialize(number, type, order_id=nil, amount=nil)
    @root_url = "https://paymentsystem.mb-samara.ru/cgi-bin/pay/"
    @number = number.to_s
    @amount = amount.to_s
    @order_id = order_id.to_s
    @type = type
  end

  def check
    er = ExternalRequest.new(check_url, true)
    get_response(er.get)
  end

  def pay
    er_pay = ExternalRequest.new(pay_url, true)
    response = get_response(er_pay.get)
  end

protected
  
  def check_url
    url = "payments.step1?agreement_number$i=#{@number}&agreement_type$i=#{@type}"
    "#{@root_url}#{url}"
  end

  def pay_url
    url = "payment.step2?agreement_id$i=#{@number}&value$n=#{@amount}&pay_date$c=#{Time.now.strftime("%d.%m.%Y")}&pay_num$i=#{@order_id}"
    "#{@root_url}#{url}"
  end

  def get_response(response)
    response = Crack::XML.parse(response)
    if response["info"]
      if response["info"]["client_name"] || response["info"]["payment_add_res"]
        reponse["info"]
      elsif response["info"]["error_txt"]
        response["info"]["error_txt"]
      else
        nil
      end
    else
      nil
    end      
  end

end