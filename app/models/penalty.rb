require 'savon'

class Penalty
  attr_reader :client

  def initialize
    @client = Savon.client(wsdl: "https://service.moneta.ru/services-providers.wsdl", wsse_auth: ["ivanova@izkh.ru", "ijkhmoneta"])
  end

  def get_providers
    response = @client.call(:get_service_providers).to_hash[:get_service_providers_response][:provider_info]
  end

  def get_penalty(reg_certificate, driver_license)
    response = @client.call(:get_next_step, message: {"providerId" => '9117', "currentStep" => "PRE", "fieldsInfo" => { "attribute" => [ {"name" => "CUSTOMFIELD:102", "value" => reg_certificate}, {"name" => "CUSTOMFIELD:103", "value" => driver_license}, {"name" => "CUSTOMFIELD:200", "value" => "1"} ] }}).to_hash[:get_next_step_response][:fields][:field]
  end
end
