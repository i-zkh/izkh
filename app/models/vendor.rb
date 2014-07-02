class Vendor < ActiveRecord::Base
  belongs_to :service_type, class_name: "ServiceType", foreign_key: "service_type_id"

  has_many :services, class_name: "Service" 
  has_many :tariff_templates

  validates_presence_of :title, :service_type_id, :commission

  def user_ids
    user_ids = []
    self.services.each {|u_id| user_ids << u_id.user_id }
    user_ids
  end
end
