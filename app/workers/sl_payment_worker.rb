# encoding: utf-8
class SlPaymentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(order_id, amount, user_account)
    SamaraLan.new(user_account, order_id, amount).pay
  end
end