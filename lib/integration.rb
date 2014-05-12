class Integration

  def self.craft_s(user_id)
    services = Service.where("user_id = ? and vendor_id = 165", user_id)
    services.each do |service|
      user_account = service.user_account

      if service.tariff_template_id
        tariff_template_id = service.tariff_template_id
        case tariff_template_id.to_i
        when 153
          account_type = "inet"
        when 158
          account_type = "voip"
        else
          account_type = nil
          raise "No account type"
        end

        cs = CraftS.new(user_account, DateTime.now.strftime("%Y-%m-%d %H:%M:%S"), account_type)
        cs_check = cs.check
        if cs_check
          if cs_check[:debt]
            amount = cs.check[:debt]
          else
            amount = 0.0
          end
        else
          amount = 0.0
        end
      end
    end
    amount
  end

  def self.global_telecom(user_id)
    services = Service.where("user_id = ? and vendor_id = 121", user_id)
    services.each do |service|
      user_account = service.user_account

      gt = GlobalTelecom.new(user_account)
      gt_check = gt.check
      if gt_check
        if gt_check[:balance]
          amount = gt.check[:balance]
        else
          amount = 0.0
        end
      else
        amount = 0.0
      end

      if amount.to_f < 0.0
        amount = (amount.to_s)[1..-1] if amount.to_f < 0.0
      end
    end
    amount
  end


  def self.jtcom(user_id)
    services = Service.where('user_id = ? and vendor_id = 16', user_id)
    services.each do |service|
      user_account = service.user_account
      if service.tariff_template_id
        tariff_template_id = service.tariff_template_id

        case tariff_template_id.to_i
        when 157
          prefix = "1"
        when 155
          prefix = "2"
        when 156
          prefix = "3"
        else
          prefix = nil
          raise "No prefix"
        end

        osmp = Osmp.new(user_account, DateTime.now.to_s(:number), prefix)
        amount = osmp.check

        if amount.to_f < 0.0
          amount = (amount.to_s)[1..-1] if amount.to_f < 0.0
        end
      end
    end
    amount
  end
end