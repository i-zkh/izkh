class Vendor < ActiveRecord::Base
  belongs_to :service_type, class_name: "ServiceType", foreign_key: "service_type_id"

  has_many :services, class_name: "Service" 
  has_many :tariff_templates, select: 'id, title, vendor_id'

  validates_presence_of :title, :service_type_id, :commission, :commission_yandex, :commission_web_money
end
