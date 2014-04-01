class MainController < ApplicationController

  layout 'main'
  
  def index
    # TODO: Values should be fetched from database
    @counter = {}
    @counter[:houses] = 13000
    @counter[:organizations] = 150
  end
end
