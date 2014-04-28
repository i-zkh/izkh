class PlacesController < ApplicationController
  def index
    @place = Place.all
  end

  def show
    @place = Place.find(params[:id])
  end

  def new
    @place = Place.new
    render partial: 'shared/places/form', status: :ok
  end

  def reg_create
    @place = Place.create!(place_params.merge!(user_id: current_user.id))
    render partial: "users/shared/registrations/step_three"
  end

  def create
    @place = Place.create!(place_params.merge!(user_id: current_user.id))
    render partial: 'shared/places/card', locals: { place: @place }, status: :ok
  end

  def update
    @place = Place.find(params[:id]).update!(place_params)
    render json: {}, status: :ok
  end

  def edit
    @place = Place.find(params[:id])
    render partial: 'shared/places/form', place: @place, status: :ok
  end

  def destroy
    place = Place.find(params[:id]).delete
    place.services.delete_all
    render json: {}, status: :ok
  end

  protected

  def place_params
    request.get? ? {} : params.require(:place).permit(:title, :city, :address, :place_type, :apartment, :building)
  end

end