class TerminalController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :require_current_user

  def success
    #POST success payment terminal
    tariff_template = if params[:payment_data][:tariff_template_id].to_i == 0
                      "" 
                    else 
                      t_t = TariffTemplate.where('id = ?', params[:payment_data][:tariff_template_id].to_i).first
                      t_t.nil? ? false : t_t.title
                    end
    vendor = Vendor.where('id = ?', params[:payment_data][:vendor_id].to_i).first
    if vendor && tariff_template
        payment_history = Transaction.new(amount: params[:payment_data][:amount].to_f, commission: params[:payment_data][:commission].to_f, payment_type: 5, payment_info: "5;#{params[:payment_data][:user_account]};;#{params[:payment_data][:amount].to_f};#{params[:payment_data][:commission]};#{vendor.title};#{tariff_template};#{Time.now.strftime("%d.%m.%Y")}", vendor_id: vendor.id, status: 1)
      if payment_history.save
        amount = payment_history.amount
        if payment_history.vendor_id.to_i == 121
          GtPaymentWorker.perform_async(DateTime.now.to_time.to_i, amount, params[:payment_data][:user_account])
        elsif payment_history.vendor_id.to_i == 135
          SlPaymentWorker.perform_async(DateTime.now.to_time.to_i, amount, params[:payment_data][:user_account]) 
        elsif payment_history.vendor_id.to_i == 165
          CraftSPaymentWorker.perform_async(DateTime.now.to_time.to_i, amount, params[:payment_data][:user_account], params[:payment_data][:tariff_template_id])
        end
        render json: {status: "success"}, status: 200
      else
        render json: {status: "fail"}, status: 500
      end
    else
      render json: {status: "fail"}, status: 500
    end
  end

  def vendors
    # GET api/1.0/terminal/vendors
    @service_types = ServiceType.all
    render 'terminal/vendors'
  end

 def terminal_payment_params
    request.get? ? {} : params.require(:payment_data).permit(:total, :amount, :commission, :user_account, :vendor_id, :tariff_template_id)
  end
end
