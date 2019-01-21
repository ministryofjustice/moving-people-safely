require 'feature_helper'

RSpec.describe 'SSO integration', type: :system, js: true do
  before do
    OauthHelper.configure_mock
  end

  scenario 'authenticating a user using SSO' do
    visit root_path
    click_on 'Start now'
    expect(page).to have_button('Sign out')
  end

  scenario 'signing a user out of the app' do
    visit root_path
    click_on 'Start now'

    click_on 'Sign out'
    expect(current_path).to eq '/users/sign_out'
    visit root_path
    expect(current_path).to eq new_session_path
  end

  context 'when authentication through SSO fails' do
    before do
      OmniAuth.config.mock_auth[:mojsso] = :invalid_credentials
    end

    scenario 'user is redirected to the login page' do
      visit root_path
      click_on 'Start now'
      expect(page).to have_link('Start now')
      expect(page).not_to have_button('Sign out')
    end
  end
end
