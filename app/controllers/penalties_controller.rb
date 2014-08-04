class PenaltiesController < ApplicationController
  def index
    @service_providers = Penalty.new.get_providers
  end

  def show
    @get_penalty = Penalty.new.get_penalty(params[:reg_certificate], params[:driver_license])
  end
end
