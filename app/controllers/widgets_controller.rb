class WidgetsController < ApplicationController

  def index
    @widgets = []
    current_user.widgets.each { |widget| @widgets << widget if widget.created_at > Time.now - 10}
  end

  def create
    widget = Widget.create!('title = ?, description = ?, sender = ?', params[:title], params[:description], params[:sender])
    params[:user_ids].each {|user_id| widget.widgetables.create(user: User.find(user_id))}
    render json: true
  end

  def update
    current_user.widgetables.where('widget_id = ?', params[:id]).each {|widget| widget.update_attribute(:status, true)}
    respond_to do |format|
      format.js { render :js => "$('#notification-#{params[:id]}').hide(\"slide\", { direction: \"right\" }, 1000);"}
    end
  end
end
