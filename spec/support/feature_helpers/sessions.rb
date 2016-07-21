module FeatureHelpers
  module Sessions
    def login
      user = create_user

      app = LoginPage.new
      app.login
      # visit root_path
      # fill_in 'user[email]', with: 'staff@some.prison.com'
      # fill_in 'user[password]', with: 'secret123'
      # click_button 'Log in'
    end

    def create_user
      User.create(
        first_name: 'Henry',
        last_name: 'Pope',
        email: 'staff@some.prison.com',
        password: 'secret123',
        password_confirmation: 'secret123')
    end
  end
end
