class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :require_current_user, unless: :devise_controller?

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    dashboard_index_path
  end

  def require_current_user
    redirect_to new_user_session_path unless current_user
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :phone, :gender, :email, :password, :city)}
  end
end
