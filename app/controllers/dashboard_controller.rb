class DashboardController < ApplicationController
  def index
    @places = current_user.places
    @precincts = Precinct.all
    @notification = current_user.notifications.where('read = ?', false).order('created_at DESC')
  end
end
