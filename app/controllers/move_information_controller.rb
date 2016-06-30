class MoveInformationController < ApplicationController
  before_action :add_destination, only: [:update]

  def show
    form.prepopulate!
    run_form_validations
    render :show, locals: { form: form }
  end

  def update
    if form.validate(params[:move_information])
      form.save
      redirect_to profile_path(escort)
    else
      flash[:form_data] = params[:move_information]
      redirect_to move_information_path(escort)
    end
  end

  private

  def form
    @_form ||= Forms::MoveInformation.new(escort.move)
  end

  def add_destination
    if params.key? 'move_add_destination'
      form.deserialize params[:move_information]
      form.add_destination
      flash[:form_data] = form.to_parameter_hash
      flash[:no_validate] = 'true'
      redirect_to move_information_path(escort)
    end
  end

  def run_form_validations
    if flash[:form_data]
      if flash[:no_validate]
        form.deserialize(flash[:form_data])
      else
        form.validate(flash[:form_data])
      end
    end
  end
end
