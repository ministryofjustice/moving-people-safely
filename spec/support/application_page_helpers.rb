module ApplicationPageHelpers
  def login(user=nil, options = { sso: { info: { permissions: [{'organisation' => 'digital.noms.moj'}]}}})
    OauthHelper.configure_mock(options.fetch(:sso))
    visit new_session_path
    click_on "Start now"
  end

  def dashboard
    @_dashboard ||= Page::Dashboard.new
  end

  def search
    @_search ||= Page::Search.new
  end

  def select_police_station
    @_select_police_station ||= Page::SelectPoliceStation.new
  end

  def detainee_details
    @_detainee_details ||= Page::Detainee.new
  end

  def new_detainee_page
    @_new_detainee_page ||= Page::Detainee.new
  end

  def move_details
    @_move_details ||= Page::Move.new
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

  def select_police_station
    @_select_police_station ||= Page::SelectPoliceStation.new
  end
end
