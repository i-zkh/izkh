# encoding: utf-8
class ChangePassWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform
    User.find(3, 25).each {|u| u.send_reset_password_instructions}
  end
end