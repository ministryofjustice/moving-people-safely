module FeatureHelpers
  module Sessions
    def login
      create_user
      visit root_path
      binding.pry
      fill_in 'user[email]', with: 'staff@some.prison.com'
      fill_in 'user[password]', with: 'secret123'
      click_button 'Log in'
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
