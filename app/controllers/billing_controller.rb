class BillingController < ApplicationController

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
end
