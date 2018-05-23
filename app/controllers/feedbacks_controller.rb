class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @form = Forms::Feedback.new
  end

  def create
    @form = Forms::Feedback.new(feedback_params)
    @form.email = current_user.email if user_signed_in?
    if @form.valid?
      ZendeskTicketCreator.new(@form, current_user).call
      redirect_to root_path, alert: t('alerts.feedback.created')
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:forms_feedback).permit(:email, :message, :prisoner_number)
  end
end
