class TerminalPayment < ActiveRecord::Base
  validates_presence_of :amount, :commission, :tariff_template_id, :total, :user_account, :vendor_id
end
