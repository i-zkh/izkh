class PaymentProcessor
  def initialize(payment_system)
    @payment_system = payment_system
  end

  def pay
    @payment_system.pay
  end

  def success
    @payment_system.success
  end

  def fail
    @payment_system.fail
  end
end