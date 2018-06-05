require 'feature_helper'

RSpec.feature 'searching for a prisoner', type: :feature do
  context 'with a valid prison number' do
    let(:prison_number) { 'A1324BC' }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/location")
    end

    scenario 'prisoner not present in MPS' do
      login
      search_with_valid_prison_number
      expect_no_results
    end

    scenario 'but user is in an establishment different from the one of the given prisoner' do
      brighton_sso_id = 'brighton.prisons.noms.moj'
      brighton_name = 'HMP Brighton'
      create(:establishment, sso_id: brighton_sso_id, name: brighton_name)
      create(:prison, nomis_id: 'BFI')
      location_service = double(Detainees::LocationFetcher)
      allow(Detainees::LocationFetcher).to receive(:new).with(prison_number).and_return(location_service)
      allow(location_service).to receive(:call).and_return({ code: 'BFI' })

      login_options = { sso: { info: { permissions: [{'organisation' => brighton_sso_id}]}} }

      login(nil, login_options)
      search_with_valid_prison_number(prison_number)
      expect_error_message("Enter a prisoner number for someone currently at #{brighton_name} to start a PER.")
    end

    scenario 'but NOMIS API is down' do
      location_service = double(Detainees::LocationFetcher)
      allow(Detainees::LocationFetcher).to receive(:new).with(prison_number).and_return(location_service)
      allow(location_service).to receive(:call).and_return(nil)
      login_options = { sso: { info: { permissions: [{'organisation' => 'unauthorized.location.noms.moj'}]}} }

      login(nil, login_options)
      search_with_valid_prison_number(prison_number)
      expect_no_results
    end

    scenario 'prisoner present with an active escort' do
      prison_number = 'A1324BC'
      escort = create(:escort, prison_number: prison_number)

      login
      search_with_valid_prison_number(prison_number)
      expect(page).to have_link('Continue PER', href: escort_path(escort))
      expect_result_with_move(escort, escort)
    end

    scenario 'prisoner present with a previously issued escort' do
      prison_number = 'A1324BC'
      escort = create(:escort, :issued, prison_number: prison_number)

      login
      search_with_valid_prison_number(prison_number)
      expect(page).to have_button('Start new PER')
      expect_result_with_move(escort, escort)
    end

    scenario 'prisoner present with no move' do
      prison_number = 'A1324BC'
      escort = create(:escort, prison_number: prison_number)

      login
      search_with_valid_prison_number(prison_number)
      expect_result_with_no_move(escort)
    end
  end

  scenario 'with an invalid prison number' do
    login
    search_with_invalid_prison_number
    expect_error_message
  end

  def search_with_valid_prison_number(prison_number = 'A1234BC')
    click_link 'Start a PER'
    fill_in 'forms_search_prison_number', with: prison_number
    click_button 'Search'
  end

  def search_with_invalid_prison_number
    click_link 'Start a PER'
    fill_in 'forms_search_prison_number', with: 'invalid-prison-number'
    click_button 'Search'
  end

  def expect_no_results
    expect(page).to have_button('Start new PER')
  end

  def expect_error_message(error_message = nil)
    error_message ||= "The prison number 'INVALID-PRISON-NUMBER' is not valid"
    expect(page).to have_content(error_message)
  end

  def expect_result_with_move(detainee, move)
    expect(page).to have_content(detainee.prison_number).
      and have_content(detainee.surname).
      and have_content(detainee.date_of_birth.strftime('%d %b %Y')).
      and have_content(move.to).
      and have_content(move.date.strftime('%d %b %Y'))
  end

  def expect_result_with_no_move(detainee)
    expect(page).to have_link('Continue PER')
    expect(page).to have_content(detainee.prison_number).
      and have_content(detainee.surname)
  end
end
