#encoding: utf-8
class ReportData

  def initialize(from, to)
    @from = from
    @to = to
  end

  def index
    payment_histories = Transaction.where("status = 1 AND created_at >= ? AND created_at < ?", @from, @to).map do |ph|
      ph.payment_info
    end
    [ payment_histories ]
  end

  def self.index_by_vendor(vendor_id, month)
    payment_histories = Transaction.where("status = 1 AND extract(month from created_at) = ? AND vendor_id = ?", month.to_i, vendor_id.to_i).map do |ph|
      ph.payment_info
    end
    [ payment_histories ]
  end
end