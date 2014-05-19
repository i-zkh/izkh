# encoding: utf-8
class GtPaymentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(order_id, amount, user_account)
    GlobalTelecom.new(user_account, order_id, amount).pay
  end
end