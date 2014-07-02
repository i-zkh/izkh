# encoding: utf-8
class NotificationListWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(notification)
    vendor = Vendor.find(notification.vendor_id)
    vendor.user_ids.each {|u_i| notification.notification_lists.create( user_id: u_i )}
  end
end