class RisksController < AssessmentsController
  private

  def model
    Risk
  end

  def assessment
    escort.risk || escort.build_risk
  end

  def multiples
    { section: 'return_instructions', field: 'must_not_return_details' }
  end

  def show_page
    escort_risks_path(escort)
  end
end
