class MetricsController < ApplicationController

  def index

  end

  def new
    
  end

  def create
    @metric = Metric.create!(metric_params.merge!(status: 0))
    render partial: 'shared/metrics/metric', locals: {metric: @metric}
  end

  def destroy

  end

protected

  def metric_params
    request.get? ? {} : params.require(:metric).permit(:meter_id, :metric)
  end

end