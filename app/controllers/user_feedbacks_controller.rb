# encoding: utf-8
class UserFeedbacksController < ApplicationController

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
    render json: UserFeedback.all
  end

  protected

  def user_feedback_params
    request.get? ? {} : params.require(:user_feedback).permit(:topic, :body, :new_version)
  end
end
