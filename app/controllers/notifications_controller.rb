class NotificationsController < ApplicationController
  skip_before_filter :require_current_user

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      UserNotificationListWorker.perform_async(@notification.vendor_id, @notification.id)
      render json: @notification
    end
  end

  def index_by_vendor
    @notifications = Notification.where(vendor_id: params[:id])
    render json: @notifications
  end

  def update
    current_user.notification_lists.where('notification_id = ?', params[:id]).each {|n| n.update_attribute(:read, true)}
    respond_to do |format|
      format.js { render :js => "$('#notification-#{params[:id]}').hide(\"slide\", { direction: \"right\" }, 1000);"}
    end

  end

  def destroy
    @notification = Notification.find(params[:id])
    if @notification.destroy
      render json: true, status: :ok
    else
      render json: false, status: 404
    end
  end

protected

  def notification_params
    request.get? ? {} : params.require(:notification).permit(:notification_text, :vendor_id)
  end

end