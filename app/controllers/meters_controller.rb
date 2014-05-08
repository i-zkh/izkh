#encoding: utf-8
class MetersController < ApplicationController

  def index
    @meters = current_user.meters
    render partial: 'index', locals: {meters: @meters}
  end

  def create
    @meter = Meter.create!(meter_params.merge!(user_id: current_user.id))
    render partial: 'shared/meters/meter', locals: {meter: @meter}
  end

  def new
    @meter = Meter.new
    render partial: 'shared/meters/form'
  end

  def destroy
    Meter.find(params[:id]).delete
    render nothing: true, status: :ok
  end

protected
  
  def meter_params
    request.get? ? {} : params.require(:meter).permit(:meter_type, :service_id)
  end

end