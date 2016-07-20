class LoginPage < SitePrison::Page
  element :email, "Email"
  element :password, "Password"
  element :log_in, "Log in"

  def login(username:, passw:)
    fill_in email, with: username
    fill_in password, with: passw
    click_button log_in
  end
end
