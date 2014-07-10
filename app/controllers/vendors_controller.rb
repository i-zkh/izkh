class VendorsController < ApplicationController
  skip_before_filter :require_current_user
  skip_before_action :verify_authenticity_token

  def by_service_type
    @vendors = Vendor.where(service_type_id: params[:service_type_id])
    render partial: 'shared/vendors/options', locals: {object: @vendors}
  end

  def by_service_type_with_pay
    @vendors = Vendor.where(service_type_id: params[:service_type_id])
    render partial: 'shared/vendors/list_of_vendors', locals: {object: @vendors}
  end

  def create
    # POST api/1.0/vendor
    @vendor = Vendor.create!(vendor_params)
    render json: @vendor.id
  end

  def index
  # GET api/1.0/servicetypes
  @service_types = ServiceType.all
  render 'shared/services/index'
  end

  def create_types
  # POST api/1.0/servicetype
  @service_type = ServiceType.create!(service_type_params)
  render 'shared/services/show'
  end

  def service_type_params
    request.get? ? {} : params.require(:service_type).permit(:title)
  end

  def vendor_params
    request.get? ? {} : params.require(:vendor).permit(:title, :service_type_id, :commission, :commission_yandex, :commission_ya_card, :commission_web_money, :commission_ya_cash_in, :shop_article_id)
  end
end
