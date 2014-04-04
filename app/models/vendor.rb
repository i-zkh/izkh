class Vendor < ActiveRecord::Base
  belongs_to :service_type, class_name: "ServiceType", foreign_key: "service_type_id"

  validates_presence_of :title, :service_type_id, :commission
end
