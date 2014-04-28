#encoding: utf-8
class UpdateDbWorker
include Sidekiq::Worker
  sidekiq_options :retry => false
    def perform
      UpdateTable.service_types
      UpdateTable.vendors
      UpdateTable.places
      UpdateTable.services
      UpdateTable.users
    end
end