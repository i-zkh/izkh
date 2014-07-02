# encoding: utf-8
class UserNotificationListWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(vendor_id, notification_id)
    vendor = Vendor.find(vendor_id)
    notification = Notification.find(notification_id)
    vendor.user_ids.each {|u_i| notification.notification_lists.create( user_id: u_i )}
  end
end