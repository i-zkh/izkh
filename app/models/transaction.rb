class Transaction < ActiveRecord::Base
  validates_presence_of :amount, :commission, :status, :user_id
  belongs_to :user, class_name: "User", foreign_key: "user_id"
end
