class ReportData

  def initialize(from, to)
    @from = from
    @to = to
  end

  def index
    payment_histories = PaymentHistory.where("status = 1 AND payment_type != '0' AND po_date_time >= ? AND po_date_time < ? AND service_id is not null", @from, @to)
      .includes(:service)
        .map do |ph| 
          if ph.service
            if ph.service.vendor_id.to_i == 16
              tariff_template_id = ph.service.tariff.tariff_template_id
              case tariff_template_id.to_i
              when 157
                user_account =  "1##{ph.service.user_account}"
              when 155
                user_account = "2##{ph.service.user_account}"
              when 156
                user_account = "3##{ph.service.user_account}"
              else
                user_account = "#{ph.service.user_account}"
              end
            elsif ph.service.vendor_id.to_i == 213
              tariff_template_id = ph.service.tariff.tariff_template_id
              case tariff_template_id.to_i
              when 209
                user_account = "Самара##{ph.service.user_account}"
              when 210
                user_account = "Новокуйбышевск##{ph.service.user_account}"
              else
                user_account = "#{ph.service.user_account}"
              end
            else
              user_account = ph.service.user_account
            end
            {
              amount: ph.amount, 
              date: ph.po_date_time, 
              address: "#{ph.service.place.city}, #{ph.service.place.street}, #{ph.service.place.building}, #{ph.service.place.apartment}", 
              vendor_id: ph.service.vendor_id, 
              user_account: user_account,
              payment_type: ph.payment_type
            }
          end
        end
        .reject {|ph| !ph}
    terminal = TerminalPayment.where("created_at >= ? AND created_at < ?", @from, @to)
    [payment_histories, terminal]
  end

  def self.index_by_vendor(vendor_id, month)
    payment_histories = Transaction.where("status = 1 AND extract(month from created_at) = ? AND vendor_id = ?", month.to_i, vendor_id.to_i).map do |ph|
      [ ph.payment_info ]
    end
  end

end