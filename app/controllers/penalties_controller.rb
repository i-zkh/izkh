class PenaltiesController < ApplicationController
  def show
    render json: Penalty.new
  end
end
