class LoginPage < SitePrison::Page
  set_url '/users/sign_in'

  element :email, "Email"
  element :password, "Password"
  element :log_in, "Log in"

  def login(user:, pass:)
    load
    fill_in email, with: user
    fill_in password, with: pass
    click_button log_in
  end
end
