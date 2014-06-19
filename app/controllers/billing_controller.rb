# encoding: utf-8
class BillingController < ApplicationController
  before_filter :admin?, only: [:check_sl, :pay_sl]

  def get_amount
    vendor_id = Service.find(params[:id]).vendor_id
    amount =  if vendor_id == 165
                Integration.craft_s(current_user.id)
              elsif vendor_id == 121
                Integration.global_telecom(current_user.id)
              elsif vendor_id == 16
                Integration.jtcom(current_user.id)
              end
    if amount
      render :text => "<p>Баланс: #{amount}</p>".html_safe
    else
       render :text => ""
    end
  end

  def check_sl
    sl = SamaraLan.new(params[:user_account])
    render text: sl.check_response
  end

  def check_mb
    mb = MyBox.new(params[:type], params[:user_account])
    render text: mb.check
  end

  def pay_mb
    mb = MyBox.new(params[:type], params[:user_account], Time.now.strftime('%Y%M%d%H%M%S'), params[:amount])
    render text: mb.pay
  end

protected
  
  def admin?
    current_user.is_admin?
  end

end
