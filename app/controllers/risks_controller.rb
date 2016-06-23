class RisksController < ApplicationController
  def show
    step.form.tap(&:prepopulate!)
    render_cell(:risks, step)
  end

  def update
    if form.validate(params[step_name])
      form.save
      redirect_to next_path
    else
      render_cell(:risks, step)
    end
  end

  def update_and_redirect_to_profile
    if form.validate(params[step_name])
      form.save
      redirect_to profile_path(escort)
    else
      render_cell(:risks, step)
    end
  end

  def add_non_association_marker
    step.form
    step.form.deserialize(params[step_name])
    step.form.add_non_association_marker

    render_cell :risks, step
  end

  private

  delegate :form, :next_path, to: :step

  def step
    @step ||= Forms::Risks::StepManager.build_step_for(step_name, escort)
  end

  def step_name
    params[:step].to_s
  end
end
