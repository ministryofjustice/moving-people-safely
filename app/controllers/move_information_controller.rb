class MoveInformationController < ApplicationController
  before_action :add_destination, only: [:update]

  def show
    form.prepopulate!
    render locals: { form: form, escort: escort }
  end

  def update
    if form.validate(params[:move_information])
      form.save
      redirect_to profile_path(escort)
    else
      render :show, locals: { form: form, escort: escort }
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
      render :show, locals: { form: form, escort: escort }
    end
  end
end
