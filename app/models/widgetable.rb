class Widgetable < ActiveRecord::Base
  belongs_to :widget
  belongs_to :user
end
