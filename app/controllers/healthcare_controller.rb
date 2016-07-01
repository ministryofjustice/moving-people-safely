class HealthcareController < ApplicationController
  include Wicked::Wizard
  steps :physical, :mental, :social, :allergies, :needs, :transport, :contact

  before_action :add_medication, only: [:update]

  def show
    populate_form
    render :show, locals: { title: form.class.name, form: form, template_name: form.class.name }
  end

  def update
    raise
    if form.validate form_params
      form.save
      redirect_after_update
    else
      flash[:form_data] = form_params
      redirect_to wizard_path
    end
  end

  private

  def form_path
    wizard_path
  end
  helper_method :form_path

  def current_question
    current_step_index + 1
  end
  helper_method :current_question

  def total_questions
    wizard_steps.size
  end
  helper_method :total_questions

  def can_go_back?
    previous_step != step
  end
  helper_method :can_go_back?

  def can_skip?
    next_step != 'wicked_finish'
  end
  helper_method :can_skip?

  def finish_wizard_path
    redirect_to profile_path(escort)
  end

  def redirect_after_update
    if params.key?('save_and_view_profile')
      redirect_to profile_path(escort)
    else
      redirect_to next_wizard_path
    end
  end

  def add_medication
    if params.key? 'needs_add_medication'
      form.deserialize form_params
      form.add_medication
      flash[:form_data] = form.to_parameter_hash
      flash[:no_validate] = 'true'
      redirect_to wizard_path
    end
  end

  def form_params
    params[step]
  end

  def populate_form
    if flash[:form_data]
      if flash[:no_validate]
        form.deserialize(flash[:form_data])
      else
        form.validate(flash[:form_data])
      end
    end
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
    }[step].new(escort.healthcare)
  end
end
