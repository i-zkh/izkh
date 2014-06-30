class NotificationsController < ApplicationController
  
  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      render json: @notification
    end
  end

  def index
    @vendor_ids = Service.vendor_ids(current_user.id)
    
    logger.info @vendor_ids
    logger.info current_user.email

    @notifications = Notification.last_week(@vendor_ids)

    render json: @notifications
  end

  def read

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