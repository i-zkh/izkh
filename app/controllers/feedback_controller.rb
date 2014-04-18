class FeedbackController < ApplicationController
  skip_before_filter :require_current_user
   def create
    params
    @metrics = current_user.metrics
    # {feedback:
    #  {subject: "Tema", message: "Test"} 
    #}
    # email = params["email"]
    # email.validate?
    # recipient = email["recipient"]
    # subject = email["subject"]
    # message = email["message"]
    #   Emailer.deliver_contact(recipient, subject, message)
    # subject = params[:feedback][:subject]
    respond_to do |format|
      format.js { render 'feedback/create' }
      end
   end

end
 