class Place < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"

  validates_presence_of :title, :place_type, :address, :user_id
  validates_uniqueness_of :title, scope: :user_id
end
