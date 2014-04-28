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
    @service = Service.find(params[:id])
    if @service.update(service_params)
      render json: {}, status: :ok
    else
      render partial: 'shared/errors', locals: { object: @service }, status: :error
    end
  end

  def create
    @service = Service.new(service_params.merge!(user_id: current_user.id))
    if @service.save      
      render partial: 'shared/services/card', locals: {service: @service}, status: :ok
    else
      render partial: 'shared/errors', locals: { object: @service }, status: :error
    end
  end

  def reg_create
    @service = Service.new(service_params.merge!(user_id: current_user.id))
    if @service.save      
      render partial: "users/shared/registrations/step_four"
    else
      render partial: 'shared/errors', locals: { object: @service }, status: :error
    end
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
