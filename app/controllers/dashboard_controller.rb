class DashboardController < ApplicationController
  def index
    @places = current_user.places
    @precincts = Precinct.all
    @widgets = current_user.widgets.where('status = ?', false).order('created_at DESC')
  end
end
