class TransactionsController < ApplicationController
  def success
    # TODO: Write a callback for successful transactions
  end

  def fail
    # TODO: Write a callback for failed transactions
  end

  protected

  def transaction_params
    request.get? ? {} : params.require(:transaction).permit(:amount, :commission, :error, :status, :user_id, :service, :place, :multiple, :included_transactions)
  end
end
