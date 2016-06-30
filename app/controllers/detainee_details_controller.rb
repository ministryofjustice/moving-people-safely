class DetaineeDetailsController < ApplicationController
  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    render :show, locals: { form: form, escort: escort }
  end

  def update
    if form.validate(params[:detainee_details])
      form.save
      redirect_to profile_path(escort)
    else
      flash[:form_data] = params[:detainee_details]
      redirect_to detainee_details_path(escort)
    end
  end

  private

  def form
    @_form ||= Forms::DetaineeDetails.new(escort.detainee)
  end
end
