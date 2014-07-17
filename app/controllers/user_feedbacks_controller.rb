# encoding: utf-8
class UserFeedbacksController < ApplicationController
  skip_before_filter :require_current_user, only: [:index]

  def new
    @show = UserFeedback.where(user_id: current_user.id) == [] ? true : false
  end

  def create
    @feedback = UserFeedback.new(user_feedback_params.merge!(user_id: current_user.id))
    if @feedback.save
      render js: "$('#feedback_error').empty();$('#feedback_error').append('Ваше сообщение отправлено, мы ответим Вам в самое ближайшее время!');$('#feedback_topic').val('');$('textarea').val('');", status: :ok
    else
      render js: "$('#feedback_error').empty();$('#feedback_error').append('Необходимо заполнить оба поля')"
    end
  end

  def index
    @feedback = []
    UserFeedback.where('created_at >= :days_ago', :days_ago  => Time.now - 30.days).each do |f|
      user = User.find(f['user_id'])
      @feedback << {topic: f['topic'], body: f['body'], new_version: f['new_version'], user_name: user.first_name, user_phone: user.phone, user_email: user.email}
    end
    render json: @feedback
  end

  protected

  def user_feedback_params
    request.get? ? {} : params.require(:user_feedback).permit(:topic, :body, :new_version)
  end
end
