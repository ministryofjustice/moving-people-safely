class HealthcareController < AssessmentsController
  before_action :skip_intro_if_police, only: %i[intro]

  private

  include WizardHelper

  def model
    Healthcare
  end

  def assessment
    escort.healthcare || escort.build_healthcare
  end

  def multiples
    { section: 'needs', field: 'medication' }
  end

  def show_page
    escort_healthcare_path(escort)
  end

  def skip_intro_if_police
    redirect_to assessment_wizard_path(assessment) if assessment.location == 'police'
  end
end
