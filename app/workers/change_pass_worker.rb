# encoding: utf-8
class ChangePassWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform
    u = User.find(25)
    UserNotification.change_pass(u)
  end
end