class OffencesController < ApplicationController
  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    render locals: { form: form }
  end

  def update
    if form.validate params[:offenses]
      form.save
      redirect_to profile_path(escort)
    else
      flash[:form_data] = params[:offenses]
      redirect_to :show
    end
  end

  private

  def form
    @_form ||= Forms::Offences.new(escort.offences)
  end
end