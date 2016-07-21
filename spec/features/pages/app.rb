class App
  def login
    @_login ||= LoginPage.new
  end

  def dashboard
    @_dashboard ||= DashboardPage.new
  end
end
