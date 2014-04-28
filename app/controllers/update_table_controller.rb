#encoding: utf-8
class UpdateTableController < ApplicationController
  def  update_db
    UpdateDbWorker.perform_async
      # UpdateTable.service_types
      # UpdateTable.vendors
      # UpdateTable.places
      # UpdateTable.services
      # UpdateTable.users
    UpdateTable.tariff_templates
    render json: true
  end
end