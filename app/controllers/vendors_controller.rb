class VendorsController < ApplicationController
  skip_before_filter :require_current_user
  def by_service_type
    @vendors = Vendor.where(service_type_id: params[:service_type_id]).map {|v| [v.title, v.id]}
    render partial: 'shared/vendors/options', locals: {object: @vendors}
  end

  def by_service_type_with_pay
    @vendors = Vendor.where(service_type_id: params[:service_type_id])
    render partial: 'shared/vendors/list_of_vendors', locals: {object: @vendors}
  end

  def create
    # POST api/1.0/vendor
    @vendor = Vendor.create!(params[:vendor])
    render 'shared/vendor/show'
  end

  def index
  # GET api/1.0/servicetypes
  @service_types = Service.all
  render 'shared/services/index'
  end

  def create_types
  # POST api/1.0/servicetype
  @service_type = Service.create!(params[:service_type])
  render 'shared/services/show'
  end

end
