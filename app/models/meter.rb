class Meter < ActiveRecord::Base
  has_many :metrics

  def last_metric
    self.metrics.last
  end
end
