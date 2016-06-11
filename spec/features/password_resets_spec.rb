require 'rails_helper'

RSpec.feature 'resetting a password', type: :feature do
  scenario 'user resets the password' do
    start_password_reset
    follow_link_received_by_email
    change_password
    expect_to_be_logged_in
  end

  def start_password_reset
    create_user
    visit new_user_password_path
    fill_in 'user[email]', with: 'staff@some.prison.com'
    click_button 'Send me reset password instructions'
  end

  def follow_link_received_by_email
    visit edit_user_password_path(reset_password_token: reset_password_token)
  end

  def change_password
    new_password = 'new_pass123'
    fill_in 'user[password]', with: new_password
    fill_in 'user[password_confirmation]', with: new_password
    click_button 'Change my password'
  end

  def expect_to_be_logged_in
    expect(current_path).to eq root_path
  end

  def reset_password_token
    last_email = ActionMailer::Base.deliveries.last
    last_email.body.to_s[/reset_password_token=([^"]+)/, 1]
  end
end
