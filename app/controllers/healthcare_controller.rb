class HealthcareController < ApplicationController
  include Wicked::Wizard
  include Wizardable

  steps :physical, :mental, :social, :allergies, :needs, :transport, :contact

  before_action :add_medication, only: [:update]

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

  def add_medication
    if params.key? 'needs_add_medication'
      form.deserialize form_params
      form.add_medication
      render :show, locals: { form: form, template_name: form.class.name }
    end
  end

  def form_params
    params[step]
  end

  def form
    @_form ||= {
      physical: Forms::Healthcare::Physical,
      mental: Forms::Healthcare::Mental,
      social: Forms::Healthcare::Social,
      allergies: Forms::Healthcare::Allergies,
      needs: Forms::Healthcare::Needs,
      transport: Forms::Healthcare::Transport,
      contact: Forms::Healthcare::Contact
    }[step].new(healthcare)
  end
end
