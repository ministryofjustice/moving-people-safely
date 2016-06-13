class HealthcareController < ApplicationController
  def show
    form = Forms::Healthcare::Physical.new(escort.healthcare)
    render_cell(:healthcare, form)
  end

  def update
    form = Forms::Healthcare::Physical.new(escort.healthcare)
    if form.validate(params[:physical])
      form.save
      redirect_to profile_path(escort)
    else
      render_cell(:healthcare, form)
    end
  end
end
