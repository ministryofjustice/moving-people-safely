class RisksController < ApplicationController
  include Wicked::Wizard
  include Wizardable

  steps :risks_to_self

  def show
    form.prepopulate!
    render :show, locals: { form: form, template_name: form.class.name }
  end

  def update
    if form.validate form_params
      form.save
      redirect_after_update
    else
      render :show, locals: { form: form, template_name: form.class.name }
    end
  end

  private

  def form_params
    params[step]
  end

  def form
    @_form ||= {
      risks_to_self: Forms::Risks::RisksToSelf
    }[step].new(escort.risks)
  end
end
