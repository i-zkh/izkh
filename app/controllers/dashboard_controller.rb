class DashboardController < ApplicationController
  skip_before_filter :require_current_user
  def index
  end
end
