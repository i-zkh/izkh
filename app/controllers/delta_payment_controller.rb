# encoding: utf-8
class DeltaPaymentController < ApplicationController
  skip_before_filter :require_current_user

  def pay
    response = HTTParty.get( "http://cabinet.izkh.ru/delta_payment?key=#{params[:key]}").parsed_response["payment"]
    response.each do |r| 
      @installation_payment = r['installation_payment']
      @service_payment = r['service_payment'] 
      @amount = @installation_payment + @service_payment
    end
  end
end
