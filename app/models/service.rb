class Service < ActiveRecord::Base
  belongs_to :place, class_name: "Place", foreign_key: "place_id"
  belongs_to :service_type, class_name: "ServiceType", foreign_key: "service_type_id"
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :vendor, class_name: "Vendor", foreign_key: "vendor_id"

  validates_presence_of :title, :place_id, :vendor_id, :service_type_id, :user_id, :user_account
  validates_uniqueness_of :title, scope: :user_id
end
