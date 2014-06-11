class MainController < ApplicationController
  skip_before_filter :require_current_user
  layout 'application'
  def index

  end

  def terminal
    
  end
end
