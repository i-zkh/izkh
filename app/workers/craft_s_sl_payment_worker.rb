# encoding: utf-8
class CraftSPaymentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(recipe_id, amount, user_account, tariff_template_id = nil) 
    amount = amount.to_f*100
    
    if tariff_template_id.to_i == 158
      account_type = "voip"
    else
      account_type = "inet"
    end
    
    CraftS.new(user_account, DateTime.now.strftime("%Y-%m-%d %H:%M:%S"), account_type, amount, recipe_id).pay
  end
end