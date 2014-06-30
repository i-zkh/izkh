class Notification < ActiveRecord::Base
  belongs_to :vendor
  has_many :notification_lists
  has_many :users, through: :notification_lists

  scope :last_week, ->(vendor_ids) { where("created_at > ?", (Time.now - 7.days)).find_all_by_vendor_id(vendor_ids) }
end
