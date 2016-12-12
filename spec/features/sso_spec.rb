require 'feature_helper'

RSpec.feature 'SSO integration', type: :feature do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:mojsso] = OmniAuth::AuthHash.new({
       "provider"=> 'mojsso',
       "uid"=> 6,
       "info"=>
        {"first_name"=>"Bob",
         "last_name"=>"Barnes",
         "email"=>"bob@example.com",
         "permissions"=>[{"organisation"=>"digital.noms.moj", "roles"=>[]}],
         "links"=>{"profile"=>"http://localhost:5000/profile", "logout"=>"http://localhost:5000/users/sign_out"}},
       "credentials"=>{"token"=>"d6cbfee29b2131637e714ed96dfae1ea9aa31015b7bf41a4e1b0ba29c27d59fc", "expires_at"=>1481560460, "expires"=>true},
       "extra"=>
        {"raw_info"=>
          {"id"=>6,
           "email"=>"bob@example.com",
           "first_name"=>"Bob",
           "last_name"=>"Barnes",
           "permissions"=>[{"organisation"=>"digital.noms.moj", "roles"=>[]}],
           "links"=>{"profile"=>"http://localhost:5000/profile", "logout"=>"http://localhost:5000/users/sign_out"}}}
      })
  end

  scenario 'authenticating a user using SSO' do
    visit root_path
    click_on 'Sign in with Mojsso'
    expect(page).to have_button('Sign out')
  end

  context 'when authentication through SSO fails' do
    before do
      OmniAuth.config.mock_auth[:mojsso] = :invalid_credentials
    end

    scenario 'user is redirected to the login page' do
      visit root_path
      click_on 'Sign in with Mojsso'
      expect(page).to have_button('Log in')
      expect(page).not_to have_button('Sign out')
    end
  end
end
