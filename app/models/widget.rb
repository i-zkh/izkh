class Widget < ActiveRecord::Base
  validates_presence_of :title
  has_many :widgetables
  has_many :users, through: :widgetables
end
