#encoding: utf-8
class UpdateTableController < ApplicationController
  skip_before_filter :require_current_user
  
  def  update_db
    #UpdateDbWorker.perform_async
    UpdateTable.service_types
    UpdateTable.vendors
    UpdateTable.places
    UpdateTable.services
    UpdateTable.tariff_templates
    UpdateTable.users
    render json: true
  end
end