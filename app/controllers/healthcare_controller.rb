class HealthcareController < AssessmentsController
  private

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
end
