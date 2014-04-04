class ServicesController < ApplicationController
  def create
    Service.create!(service_params)
    render json: {}
  end
  
  protected

  def service_params
    request.get? ? {} : params.require(:service).permit(:title, :place_id, :user_account, :user_id, :vendor_id, :service_type_id)
  end
end
