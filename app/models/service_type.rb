class ServiceType < ActiveRecord::Base
  has_many :vendors, class_name: "Vendor"
  has_many :services, class_name: "Service"
  has_many :tariff_templates
  
  validates_presence_of :title
end
