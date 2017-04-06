module ApplicationPageHelpers
  def login(user=nil)
    OauthHelper.configure_mock
    visit new_session_path
    click_on "Sign in with Mojsso"
  end

  def dashboard
    @_dashboard ||= Page::Dashboard.new
  end

  def detainee_details
    @_detainee_details ||= Page::Detainee.new
  end

  def new_detainee_page
    @_new_detainee_page ||= Page::Detainee.new
  end

  def move_details
    @_move_details ||= Page::MoveDetails.new
  end

  def move_print_page
    @_move_print_page ||= Page::MovePrint.new
  end

  def escort_page
    @_escort_page ||= Page::Escort.new
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

  def risk_summary
    @_risk_summary ||= Page::RiskSummary.new
  end

  def healthcare_summary
    @_healthcare_summary ||= Page::HealthcareSummary.new
  end
end
