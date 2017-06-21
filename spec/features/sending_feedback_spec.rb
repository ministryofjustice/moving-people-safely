require 'feature_helper'

RSpec.feature 'sending feedback', type: :feature do
  scenario 'logged in user sends feedback' do
    stub_zendesk_api_request

    establishment_sso_id = 'bedford.prisons.noms.moj'
    establishment_nomis_id = 'BDI'
    prison = create(:prison, name: 'HMP Bedford', sso_id: establishment_sso_id, nomis_id: establishment_nomis_id)
    login_options = { sso: { info: { permissions: [{'organisation' => establishment_sso_id}]}} }

    login(nil, login_options)

    visit new_feedback_path
    fill_in 'Prisoner number', with: 'A1234BC'
    fill_in 'Your message', with: 'Problem creating PER for that prisoner'

    click_button 'Send'

    expect(page).to have_content('Your message has been sent')
  end

  scenario 'not logged in user sends feedback' do
    stub_zendesk_api_request

    visit new_feedback_path
    fill_in 'Your email', with: 'user@example.com'
    fill_in 'Your message', with: 'Problem creating PER for that prisoner'

    click_button 'Send'

    expect(page).to have_content('Your message has been sent')
  end
end
