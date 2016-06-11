require 'rails_helper'

RSpec.feature 'authentication', type: :feature do
  scenario 'user log in' do
    login
    expect_to_be_logged_in

    sign_out
    expect_to_not_be_logged_in
  end

  scenario 'wrong credentials' do
    visit '/'
    login_with_wrong_credentials
    expect_to_not_be_logged_in
  end

  def login_with_wrong_credentials
    fill_in 'user[email]', with: 'wrong'
    fill_in 'user[password]', with: 'credentials'
    click_button 'Log in'
  end

  def sign_out
    click_button 'Sign out'
  end

  def expect_to_be_logged_in
    expect(current_path).to eq root_path
  end

  def expect_to_not_be_logged_in
    expect(current_path).to eq new_user_session_path
  end
end
