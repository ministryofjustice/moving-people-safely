class RisksController < AssessmentsController
  helper_method :escort, :risk

  def automation
    api_client = Nomis::Api.instance
    @nomis_alerts = api_client.get("/offenders/#{escort.prison_number}/alerts?include_inactive=true")
    @automated_risk = Detainees::RiskMapper.new(@nomis_alerts, escort.move.date).call
  end

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

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def risk
    @risk ||= if %w[new create].include?(params[:action])
                escort.build_risk
              else
                escort.risk || raise(ActiveRecord::RecordNotFound)
              end
  end
end
