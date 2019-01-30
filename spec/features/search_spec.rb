require 'feature_helper'

RSpec.feature 'searching for a prisoner', type: :feature do
  context 'from prison' do
    context 'with a valid prison number' do
      let(:prison_number) { 'A1324BC' }

      before do
        stub_nomis_api_request(:get, "/offenders/#{prison_number}/location")
      end

      scenario 'prisoner not present in MPS' do
        login
        dashboard.click_start_a_per
        search.search_prison_number(prison_number)
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
        dashboard.click_start_a_per
        search.search_prison_number(prison_number)
        expect_prison_error_message("Enter a prisoner number for someone currently at #{brighton_name} to start a PER.")
      end

      scenario 'but NOMIS API is down' do
        location_service = double(Detainees::LocationFetcher)
        allow(Detainees::LocationFetcher).to receive(:new).with(prison_number).and_return(location_service)
        allow(location_service).to receive(:call).and_return(nil)
        login_options = { sso: { info: { permissions: [{'organisation' => 'unauthorized.location.noms.moj'}]}} }

        login(nil, login_options)
        dashboard.click_start_a_per
        search.search_prison_number(prison_number)
        expect_no_results
      end

      scenario 'prisoner present with an active escort' do
        escort = create(:escort, :completed, prison_number: prison_number)

        login
        dashboard.click_start_a_per
        search.search_prison_number(prison_number)
        expect(page).to have_link('Continue PER', href: escort_path(escort))
        expect_result_with_move(escort)
      end

      scenario 'prisoner present with a previously issued escort' do
        escort = create(:escort, :issued, prison_number: prison_number)

        login
        dashboard.click_start_a_per
        search.search_prison_number(prison_number)
        expect(page).to have_button('Start new PER')
        expect_result_with_move(escort)
      end
    end

    scenario 'with an invalid prison number' do
      login
      dashboard.click_start_a_per
      search.search_prison_number('invalid-prison-number')
      expect_prison_error_message
    end
  end

  context 'from police' do
    before do
      create(:police_custody, name: 'Banbury Police Station')

      login_options = { sso: { info: { permissions: [{'organisation' => User::POLICE_ORGANISATION}]}} }
      login(nil, login_options)

      select_police_station.select_station('Banbury Police Station')

      dashboard.click_start_a_per
    end

    context 'with a valid pnc number' do
      let(:searched_pnc_number) { '12/12345A' }
      let(:db_pnc_number) { '12/0012345A' }

      scenario 'prisoner not present in MPS' do
        search.search_pnc_number(searched_pnc_number)
        expect_no_results
      end

      scenario 'prisoner present with an active escort' do
        escort = create(:escort, :completed, :from_police, pnc_number: db_pnc_number)

        search.search_pnc_number(searched_pnc_number)
        expect(page).to have_link('Continue PER', href: escort_path(escort))
        expect_result_with_move(escort, searched_pnc_number)
      end

      scenario 'prisoner present with a previously issued escort' do
        escort = create(:escort, :issued, :from_police, pnc_number: db_pnc_number)

        search.search_pnc_number(searched_pnc_number)
        expect(page).to have_button('Start new PER')
        expect_result_with_move(escort, searched_pnc_number)
      end
    end

    context 'with a valid old pnc number' do
      let(:pnc_number) { '14/93785A' }

      scenario 'prisoner not present in MPS' do
        search.search_pnc_number(pnc_number)
        expect_no_results
      end
    end

    scenario 'with an invalid pnc number' do
      search.search_pnc_number('invalid-pnc-number')
      expect_police_error_message
    end
  end

  def expect_no_results
    expect(page).to have_button('Start new PER')
  end

  def expect_prison_error_message(error_message = nil)
    error_message ||= "The prison number 'INVALID-PRISON-NUMBER' is not valid"
    expect(page).to have_content(error_message)
  end

  def expect_police_error_message(error_message = nil)
    error_message ||= "The PNC number 'INVALID-PNC-NUMBER' is not valid"
    expect(page).to have_content(error_message)
  end

  def expect_result_with_move(escort, searched_number = escort.number)
    expect(page).to have_content(searched_number.upcase).
      and have_content(escort.detainee_surname).
      and have_content(escort.detainee.date_of_birth.strftime('%d %b %Y')).
      and have_content(escort.move.to).
      and have_content(escort.move_date.strftime('%d %b %Y'))
  end
end
