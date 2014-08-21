# encoding: utf-8
class CraftSPaymentWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(recipe_id, amount, user_account, tariff_template_id = nil) 
    amount = amount.to_f*100
    transaction = Transaction.find_by_order_id(recipe_id)
    tariff_template_id ||= Service.find(transaction.service).tariff_template_id

    case tariff_template_id
    when 153
      account_type = "inet"
    when 158
      account_type = "voip"
    else
      account_type = nil
      raise "No account type"
    end
    
    CraftS.new(user_account, DateTime.now.strftime("%Y-%m-%d %H:%M:%S"), account_type, amount, recipe_id).pay
  end
end