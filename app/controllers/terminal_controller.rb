class TerminalController < ApplicationController
  skip_before_filter :require_current_user
  skip_before_action :verify_authenticity_token

  def success
    #POST success payment terminal
    payment_history = TerminalPayment.new(params[:payment_data])
    if payment_history.save
      amount = payment_history.amount
      if payment_history.vendor_id.to_i == 121
        GtPaymentWorker.perform_async(nil, DateTime.now.to_time.to_i, amount, payment_history.user_account)
      elsif payment_history.vendor_id.to_i == 135
        SlPaymentWorker.perform_async(nil, DateTime.now.to_time.to_i, amount, payment_history.user_account) 
      elsif payment_history.vendor_id.to_i == 165
        # CraftSPaymentWorker.perform_async(nil, DateTime.now.to_time.to_i, amount, payment_history.user_account, payment_history.tariff_template_id)
      end

      render json: {status: "success"}, status: 200
    else
      render json: {staus: "fail"}, status: 500
    end
  end

  def vendors
    # GET api/1.0/terminal/vendors
    @service_types = ServiceType.all
    render 'terminal/vendors'
  end
end
