class App
  include FactoryGirl::Syntax::Methods
  include Capybara::DSL

  def login(user=nil)
    user ||= create(:user)
    visit '/users/sign_in'
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
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
