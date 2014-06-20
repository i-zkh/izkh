#encoding: utf-8
class MyBox
  def initialize(number, type, order_id=nil, amount=nil)
    @root_url = "https://igkh.mb-samara.ru/cgi-bin/pay/igkh/"

    @number = number.to_s
    @amount = amount.to_s
    @order_id = order_id.to_s
    @type = type.to_s
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
    url = "payments.step1?agreement_number=#{@number}&agreement_type=#{@type}"
    "#{@root_url}#{url}"
  end

  def pay_url
    url = "payments.step2?agreement_number=#{@number}&agreement_type=#{@type}&value=#{@amount}&pay_date=#{Time.now.strftime("%d.%m.%Y")}&pay_num=#{@order_id}"
    "#{@root_url}#{url}"
  end

  def get_response(response)
    response = Crack::XML.parse(response)
    if response["info"]
      if response["info"]["client_name"] || response["info"]["payment_add_res"]
        response["info"]
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