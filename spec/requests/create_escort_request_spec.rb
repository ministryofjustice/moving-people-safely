require 'rails_helper'

RSpec.describe 'Create escort request', type: :request do
  let(:prison_number) { 'A1234AY' }
  let(:user) { create(:user) }
  let(:sso_config) { { info: { permissions: user.permissions } } }

  before do
    sign_in(user, sso: sso_config)
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/location")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/charges")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts")
  end

  context 'when the user is in an establishment different from the one of the given prisoner' do
    let(:brighton_sso_id) { 'brighton.prisons.noms.moj' }
    let(:brighton_name) { 'HMP Brighton' }
    let(:prison_code) { 'BDI' }
    let!(:prison) { create(:prison, nomis_id: prison_code) }
    let!(:user_establishment) { create(:establishment, sso_id: brighton_sso_id, name: brighton_name) }
    let(:location_service) { double(Detainees::LocationFetcher) }
    let(:location_response) { { code: prison_code } }
    let(:sso_config) { { info: { permissions: [{'organisation' => brighton_sso_id}] } } }

    before do
      allow(Detainees::LocationFetcher).to receive(:new).with(prison_number).and_return(location_service)
      allow(location_service).to receive(:call).and_return(location_response)
    end

    it 'does not create a new escort record and redirects to homepage' do
      expect {
        post '/escorts', params: { escort: { prison_number: prison_number } }
      }.not_to change { Escort.where(prison_number: prison_number).count }.from(0)

      expect(flash[:error]).to eq("Enter a prisoner number for someone currently at #{brighton_name} to start a PER.")
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when there is no previous escort for given prison number' do
    it 'creates a brand new escort record and redirects to the new detainee form' do
      expect {
        post '/escorts', params: { escort: { prison_number: prison_number } }
      }.to change { Escort.where(prison_number: prison_number).count }.from(0).to(1)

      escort = Escort.where(prison_number: prison_number).first
      expect(escort.detainee).to be_nil
      expect(escort.move).to be_nil

      expect(response).to redirect_to(new_escort_detainee_path(escort, prison_number: prison_number))
    end
  end

  context 'when there is a previous escort for given prison number' do
    let!(:existent_escort) { create(:escort, :completed, prison_number: prison_number) }

    it 'creates a new escort record with the data from the existent escort and redirects to the edit detainee form' do
      expect {
        post '/escorts', params: { escort: { prison_number: prison_number } }
      }.to change { Escort.where(prison_number: prison_number).count }.from(1).to(2)

      escort = Escort.where(prison_number: prison_number).first
      expect(escort.detainee).to be_an_instance_of(Detainee)
      expect(escort.move).to be_nil

      expect(response).to redirect_to(edit_escort_detainee_path(escort))
    end
  end
end
