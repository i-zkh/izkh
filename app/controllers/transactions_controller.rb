class TransactionsController < ApplicationController
  skip_before_filter :require_current_user
  def success
    # TODO: Write a callback for successful transactions
  end

  def fail
    # TODO: Write a callback for failed transactions
  end
  def index
    
  end
  protected

  def transaction_params
    request.get? ? {} : params.require(:transaction).permit(:amount, :commission, :error, :status, :user_id, :service, :place, :multiple, :included_transactions)
  end
end
