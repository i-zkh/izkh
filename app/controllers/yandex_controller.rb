class YandexController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :require_current_user

  def success
    #POST success payment yandex
    vendor = Vendor.find_by_shop_article_id(params[:shop_article_id].to_i)
    payment_history = Transaction.new(amount: params[:amount].to_f, commission: params[:commission].to_f, payment_type: params[:payment_type], payment_info: "#{params[:payment_type]};#{params[:user_account]};;#{params[:amount].to_f};#{params[:commission]};#{vendor.title};#{TariffTemplate.find(params[:tariff_template_id].to_i).title};#{Time.now.strftime("%d.%m.%y")}", vendor_id: vendor.id, status: 1)
    if payment_history.save
      amount = payment_history.amount
      # if payment_history.vendor_id.to_i == 121
      #   GtPaymentWorker.perform_async(nil, DateTime.now.to_time.to_i, amount, params[:user_account])
      # elsif payment_history.vendor_id.to_i == 135
      #   SlPaymentWorker.perform_async(nil, DateTime.now.to_time.to_i, amount, params[:user_account]) 
      # elsif payment_history.vendor_id.to_i == 165
      #   CraftSPaymentWorker.perform_async(nil, DateTime.now.to_time.to_i, amount, params[:user_account], payment_history.tariff_template_id)
      # end

      render json: {status: "success"}, status: 200
    else
      render json: {staus: "fail"}, status: 500
    end
  end  
end
