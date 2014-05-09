# encoding: utf-8
class ChangePassWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform
    u = User.find(25)
    u.send_reset_password_instructions
  end
end