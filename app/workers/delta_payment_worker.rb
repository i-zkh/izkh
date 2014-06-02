# encoding: utf-8
class GtPaymentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(key)
    response = HTTParty.post( "http://cabinet.izkh.ru/delta_success_pay",
          :body => {:key => key}.to_json,
          :headers => {'Content-Type' => 'application/json'})

    mandrill = Mandrill::API.new 'NToYNXQZRClqYQkDai6ujg'

    message = {  
      :subject=> "АйЖКХ",  
      :from_name=> "АйЖКХ",  
      :text=>"Оплата услуг компании DELTA",  
      :to=>[{
          :email=> "iva.anastya@gmail.com",
      }],  
      :html=>
        "<html><h3>Заявка на оплату услуг компании DELTA</h3>
        </html>",
      :from_email=>"out@izkh.ru"
    } 
    mandrill.messages.send message
  end
end