class TutorialsController < ApplicationController

  def off
    # POST off tutorial for current user
    current_user.update_attribute(:tutorial, false)
    render json: true
  end
end