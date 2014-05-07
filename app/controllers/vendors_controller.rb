class VendorsController < ApplicationController

  def by_service_type
    @vendors = Vendor.where(service_type_id: params[:service_type_id]).map {|v| [v.title, v.id]}
    render partial: 'shared/vendors/list_of_vendors', locals: {object: @vendors}
  end
end
