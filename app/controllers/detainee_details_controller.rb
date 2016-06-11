class DetaineeDetailsController < ApplicationController
  def show
    form = Forms::DetaineeDetails.new(escort.detainee)
    view_context = FormModelPair.new(form, escort)

    render_cell :detainee_details, view_context
  end

  def update
    form = Forms::DetaineeDetails.new(escort.detainee)
    view_context = FormModelPair.new(form, escort)

    if form.validate(params[:detainee_details])
      form.save
      render_cell :detainee_details, view_context
    else
      render_cell :detainee_details, view_context
    end
  end

  FormModelPair = Struct.new(:form, :escort)
end
