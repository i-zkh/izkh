require 'uri'
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
    @place.index = zip(@place)
    if @place.save
      render partial: 'shared/places/card', locals: { place: @place }, status: :ok
    else
      render partial: 'shared/errors', locals: { object: @place }, status: :error
    end
  end

  def update
    @place = Place.find(params[:id])
    if @place.update(place_params)
      @place.index = zip(@place)
      @place.save
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

  def zip(place)
    begin
      kladrToken = '5322ef24dba5c7d326000045'
      kladrKey = '60d44104d6e5192dcdc610c10ff4b2100ece9604'
      url = URI.encode("http://kladr-api.ru/api.php?query=#{place.city}&contentType=city&withParent=1&limit=1&token=#{kladrToken}&key=#{kladrKey}")
      kladr_city_id = HTTParty.get(URI.parse(url))['result'].first['id'] 
      url = URI.encode("http://kladr-api.ru/api.php?cityId=#{kladr_city_id}&query=#{place.address}&contentType=street&withParent=1&limit=1&token=#{kladrToken}&key=#{kladrKey}")
      kladr_street_id = HTTParty.get(URI.parse(url))['result'].first['id']
      url = URI.encode("http://kladr-api.ru/api.php?streetId=#{kladr_street_id}&query=#{place.building}&contentType=building&withParent=1&limit=1&token=#{kladrToken}&key=#{kladrKey}")
      kladr_building_id = HTTParty.get(URI.parse(url))['result'].first['zip']
    rescue Exception => e
      ""
    else 
      kladr_building_id
    end
  end

  def place_params
    request.get? ? {} : params.require(:place).permit(:title, :city, :address, :place_type, :apartment, :building, :user_id)
  end

end