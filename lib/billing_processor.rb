require 'uri'
class BillingProcessor
  def initialize(billing)
    @billing = billing
  end

  def check
    @billing.check
  end

  def pay
    @billing.pay
  end

end