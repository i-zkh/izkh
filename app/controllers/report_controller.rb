class ReportController < ApplicationController
  skip_before_filter :require_current_user

  def index_from_to
    # GET api/1.0/report_from_to
    # fetches all transactions in [from..to] period
    # params: from, to
    # renders json:
    # payload: [{user_account, amount, date, address, vendor_id}]
    payload = ReportData.new(params[:from], params[:to])
    render json: {payload: payload.index.first, terminal: payload.index.last}
  end

  def index_monthly_by_vendor
    # GET api/1.0/report_monthly
    # fetches all transactions for given month and vendor_id
    # params: month, vendor_id
    # renders json:
    # payload: [{user_account, amount, date, address, vendor_id}]
    payload = ReportData.index_by_vendor(params[:vendor_id], params[:month])
    render json: {payment_history: payload.first}
  end
end
