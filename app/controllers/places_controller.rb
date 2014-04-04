class PlacesController < ApplicationController
  def index
    @place = Place.all
  end

  def show
    @place = Place.find(params[:id])
  end

  def create
    @place = Place.create!(place_params)
    render json: {}
  end

  def update
    @place = Place.find(params[:id]).update!(place_params)
  end

  def edit
    @place = Place.find(params[:id])
  end

  def destroy
    place = Place.find(params[:id])
  end

  protected

  def place_params
    request.get? ? {} : params.require(:place).permit(:title, :city, :address, :user_id, :place_type, :apartment)
  end

end
