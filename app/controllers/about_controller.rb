class AboutController < ApplicationController
  skip_before_filter :require_current_user
  def index
  end
end
