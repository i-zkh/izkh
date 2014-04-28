class DashboardController < ApplicationController
  def index
    @places = current_user.places
  end
end
