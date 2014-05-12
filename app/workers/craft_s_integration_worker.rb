# encoding: utf-8
class CraftSIntegrationWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false

	def perform(user_id)
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
					account.update_attributes!(amount: amount, status: -1) if amount

			end
		end
	end

end