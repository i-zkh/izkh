# encoding: utf-8
class ChangePassWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform
    User.all.each {|u| u.send_reset_password_instructions}
  end
end