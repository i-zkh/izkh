class TariffTemplate < ActiveRecord::Base
  belongs_to :service_type, foreign_key: :service_type_id
  belongs_to :vendor
end
