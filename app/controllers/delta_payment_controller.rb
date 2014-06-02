# encoding: utf-8
class DeltaPaymentController < ApplicationController
  skip_before_filter :require_current_user

  def pay
    response = HTTParty.get( "http://cabinet.izkh.ru/delta_payment?key=#{params[:key]}").parsed_response["payment"]
    @installation_payment = response['installation_payment'].to_i
    @service_payment = response['service_payment'].to_i
    @amount = @installation_payment + @service_payment
  end
end
