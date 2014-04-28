class ServicesController < ApplicationController

  def by_place
    @services = Service.where(place_id: params[:id])
    render partial: 'shared/services/index', locals: {services: @services}, status: :ok
  end

  def show
    @service = Service.find(params[:id])
    render partial: 'shared/services/detailed'
  end

  def new
    @service = Service.new
    render partial: 'shared/services/form'
  end

  def edit
    @service = Service.find(params[:id])
    render partial: 'shared/services/form'
  end

  def update
    @service = Service.find(params[:id]).update!(service_params)
    render json: {}, status: :ok
  end

  def create
    @service = Service.create!(service_params.merge!(user_id: current_user.id))
    render partial: 'shared/services/card', locals: {service: @service}, status: :ok
  end

  def reg_create
    @service = Service.create!(service_params.merge!(user_id: current_user.id))
    render partial: "users/shared/registrations/step_four"
  end

  def destroy
    Service.find(params[:id]).delete
    render json: {}, status: :ok
  end

  protected

  def service_params
    request.get? ? {} : params.require(:service).permit(:title, :place_id, :user_account, :vendor_id, :service_type_id)
  end
end
