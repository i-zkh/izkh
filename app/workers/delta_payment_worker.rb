# encoding: utf-8
class DeltaPaymentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(key)
    response = HTTParty.post( "http://cabinet.izkh.ru/delta_success_pay",
          :body => {:key => key}.to_json,
          :headers => {'Content-Type' => 'application/json'})
  end
end