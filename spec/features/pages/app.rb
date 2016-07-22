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
end
