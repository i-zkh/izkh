class PlacesController < ApplicationController
  def index
    @place = Place.all.order('created_at desc')
  end

  def show
    @place = Place.find(params[:id])
  end

  def new
    @place = Place.new
    render partial: 'shared/places/form', status: :ok
  end

  def reg_create
    @place = Place.new(place_params.merge!(user_id: current_user.id))
    if @place.save
      render partial: "users/shared/registrations/step_three"
    else
      render partial: 'shared/errors', locals: { object: @place }, status: :error
    end
  end

  def create
    @place = Place.new(place_params.merge!(user_id: current_user.id))
    if @place.save
      render partial: 'shared/places/card', locals: { place: @place }, status: :ok
    else
      render partial: 'shared/errors', locals: { object: @place }, status: :error
    end
  end

  def update
    @place = Place.find(params[:id])
    if @place.update(place_params)
      render json: {}, status: :ok
    else
      render partial: 'shared/errors', locals: { object: @place }, status: :error
    end
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
    request.get? ? {} : params.require(:place).permit(:title, :city, :address, :place_type, :apartment, :building, :user_id)
  end

end