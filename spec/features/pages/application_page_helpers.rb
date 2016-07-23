module ApplicationPageHelpers
  def login(user)
    @_login ||= LoginPage.new.login(user)
  end

  def dashboard
    @_dashboard ||= DashboardPage.new
  end

  def detainee_details
    @_detainee_details ||= DetaineeDetailsPage.new
  end

  def move_details
    @_move_details ||= MoveDetailsPage.new
  end

  def profile
    @_profile ||= ProfilePage.new
  end

  def healthcare
    @_healthcare ||= HealthcarePage.new
  end

  def risk
    @_risk ||= RiskPage.new
  end
end
