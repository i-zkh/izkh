class LandingsController < ApplicationController
  skip_before_filter :require_current_user
  layout 'landing'
  
  def index
    # TODO: Values should be fetched from database
    @counter = {}
    @counter[:houses] = 13000
    @counter[:organizations] = 158
  end
end
