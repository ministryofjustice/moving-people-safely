require 'rails_helper'

RSpec.feature 'inviting a user', type: :feature do
  scenario 'user accepts an invitation' do
    invite_user
    follow_link_received_by_email

    set_invalid_password
    expect_page_to_have_validation_errors

    set_valid_password
    expect_to_be_logged_in
  end

  scenario 'invitation token does not exist' do
    visit accept_user_invitation_path(invitation_token: 'gibberish')
    expect_to_be_sent_to_login_page
  end

  scenario 'invitation token expires after 3 days' do
    invite_user
    travel_to(4.days.from_now) do
      follow_link_received_by_email
      expect_to_be_sent_to_login_page
    end
  end

  def invite_user
    User.invite!(email: 'staff@some.prison.com')
  end

  def follow_link_received_by_email
    visit accept_user_invitation_path(invitation_token: invitation_token)
  end

  def set_invalid_password
    set_password 'invalid'
  end

  def set_valid_password
    set_password 'secret123'
  end

  def set_password(password)
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    click_button 'Set my password'
  end

  def expect_page_to_have_validation_errors
    expect(page).to have_content 'Password is too short'
  end

  def expect_to_be_logged_in
    expect(current_path).to eq root_path
  end

  def expect_to_be_sent_to_login_page
    expect(current_path).to eq new_user_session_path
  end

  def invitation_token
    last_email = ActionMailer::Base.deliveries.last
    last_email.body.to_s[/invitation_token=([^"]+),/, 1]
  end
end
