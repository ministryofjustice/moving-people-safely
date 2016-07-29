module ApplicationPageHelpers
  def login(user=nil)
    @_login ||= Page::Login.new.login(user)
  end

  def dashboard
    @_dashboard ||= Page::Dashboard.new
  end

  def detainee_details
    @_detainee_details ||= Page::DetaineeDetails.new
  end

  def move_details
    @_move_details ||= Page::MoveDetails.new
  end

  def profile
    @_profile ||= Page::Profile.new
  end

  def healthcare
    @_healthcare ||= Page::Healthcare.new
  end

  def risk
    @_risk ||= Page::Risk.new
  end

  def offences
    @_offences ||= Page::Offences.new
  end

  def healthcare_summary
    @_h_summary ||= Page::HealthcareSummary.new
  end

  def risk_summary
    @_r_summary ||= Page::RiskSummary.new
  end
end
