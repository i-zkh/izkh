class Penalty
  attr_reader :service_providers

  def initialize
    client = Savon::Client.new("https://service.moneta.ru/services-providers.wsdl")
    response = client.request :web, :get_service_providers
  end
end
