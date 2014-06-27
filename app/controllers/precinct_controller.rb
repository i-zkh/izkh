class PrecinctController < ApplicationController

  def widget_precinct
    @place = Place.find(params[:id])
    @precinct = Ovd.widget_precinct(@place.address, @place.building)
    render partial: 'precinct/widget'
  end

  def list_of_precincts
    render partial: 'precinct/list_of_precincts'
  end

  def parse_precinct
    # GET api/1.0/precinct/create
    Ovd.clean_up
    Ovd.xls_parser
    render json: {status: "success"}
  end

end
