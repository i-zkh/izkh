class DashboardController < ApplicationController
  skip_before_filter :require_current_user
  def index
    @places = current_user.places
    @widgets = current_user.widgets.where('status = ?', false).order('created_at DESC')
  end
end
