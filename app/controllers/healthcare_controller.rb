class HealthcareController < ApplicationController
  include Wicked::Wizard

  steps :physical, :mental, :social, :allergies, :needs, :transport, :contact

  def show
    form.tap(&:prepopulate!)
    run_form_validations
    render html: healthcare_form_cell, layout: true
  end

  def update
    if params.key? 'needs_add_medication'
      form.deserialize permitted_params
      form.add_medication
      flash[:form_data] = form.to_parameter_hash
      flash[:no_validate] = 'true'
      redirect_to wizard_path
    elsif form.validate permitted_params
      form.save
      if params.key? 'save_and_view_profile' || end_of_wizard?
        redirect_to profile_path(escort)
      else
        redirect_to next_wizard_path
      end
    else
      flash[:form_data] = permitted_params
      redirect_to wizard_path
    end
  end

  private

  def healthcare_form_cell
    cell = cell(:healthcare, form)

    cell.form_title = form.class.name
    cell.prev_path = previous_wizard_path if is_prev_step?
    cell.next_path = next_wizard_path if is_next_step?
    cell.current_question = current_step_index + 1
    cell.total_questions = wizard_steps.size
    cell.template_name = form.class.name
    cell.form_path = wizard_path

    cell
  end

  def permitted_params
    params[step]
  end

  def is_prev_step?
    previous_step != step
  end

  def end_of_wizard?
    next_step == 'wicked_finish'
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
