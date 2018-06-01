class DetaineesController < ApplicationController
  before_action :redirect_unless_document_editable
  helper_method :escort, :form

  def update
    if form.validate(params[:detainee])
      form.save
      redirect_to escort_path(escort)
    else
      render :edit
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def form
    @form ||= Forms::Detainee.new(escort)
  end

  def permitted_params(params)
    params.slice(*Forms::Detainee.properties)
  end
end
