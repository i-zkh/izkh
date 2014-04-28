class Vendor < ActiveRecord::Base
  belongs_to :service_type, class_name: "ServiceType", foreign_key: "service_type_id"

  has_many :services, class_name: "Service" 

  validates_presence_of :title, :service_type_id, :commission
end
