class OffencesController < ApplicationController
  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    render locals: { form: form }
  end

  def update
    if form.validate form_data
      form.save
      redirect_to profile_path(escort)
    else
      flash[:form_data] = form_data
      redirect_to offences_path(escort)
    end
  end

  private

  def form_data
    params.require(:offences)
  end

  def form
    @_form ||= OffencesForm.new(escort.offences)
  end
end