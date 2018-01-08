require 'rails_helper'

RSpec.describe 'Create escort request', type: :request do
  let(:prison_number) { 'A1234AY' }
  let(:user)          { create(:user) }
  let(:sso_config)    { { info: { permissions: user.permissions } } }

  let(:nomis_detainee_path) { "/offenders/#{prison_number}" }
  let(:nomis_image_path)    { "#{nomis_detainee_path}/image" }
  let(:nomis_offences_path) { "#{nomis_detainee_path}/charges" }
  let(:nomis_location_path) { "#{nomis_detainee_path}/location" }

  let(:fixture_offences_path) do
    Rails.root.join('spec', 'support', 'fixtures', 'valid-nomis-charges.json')
  end
  
  let(:offences_json) { File.read(fixture_offences_path) }

  before do
    sign_in(user, sso: sso_config)
    stub_nomis_api_request(:get, nomis_detainee_path)
    stub_nomis_api_request(:get, nomis_image_path,
      body: { image: 'an-image' }.to_json)
    stub_nomis_api_request(:get, nomis_offences_path, body: offences_json)
    stub_nomis_api_request(:get, nomis_location_path)
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
    it 'creates a brand new escort record and redirects to the edit detainee form' do
      expect {
        post '/escorts', params: { escort: { prison_number: prison_number } }
      }.to change { Escort.where(prison_number: prison_number).count }.from(0).to(1)

      escort = Escort.where(prison_number: prison_number).first
      expect(escort.detainee).not_to be_nil
      expect(escort.move).to be_nil

      expect(response).to redirect_to(edit_escort_detainee_path(escort))
    end

    it 'retrieves details, image and offences from remote API' do
      expect(Nomis::Api.instance).to receive(:get).with(nomis_detainee_path)
      expect(Nomis::Api.instance).to receive(:get).with(nomis_image_path)
      expect(Nomis::Api.instance).to receive(:get).with(nomis_offences_path)
      post '/escorts', params: { escort: { prison_number: prison_number } }
    end

    it 'does not set any flash error messages' do
      post '/escorts', params: { escort: { prison_number: prison_number } }
      expect(flash[:warning]).to be_empty
    end

    context 'when detainee details cannot be prefetched' do
      before do
        stub_nomis_api_request(:get, nomis_detainee_path, status: 500)
      end

      it 'sets a flash error message indicating the details could not be prefetched' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to eq(['Look-Up function is not currently available. Please enter person details manually or try again later'])
      end
    end

    context 'when image details cannot be prefetched' do
      before do
        stub_nomis_api_request(:get, nomis_image_path, status: 500)
      end

      it 'sets a flash error message indicating the image could not be prefetched' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to eq(['Image Look-Up function is not currently available. Please try again later'])
      end
    end

    context 'when offences cannot be prefetched' do
      before do
        stub_nomis_api_request(:get, nomis_offences_path, status: 500)
      end

      it 'sets a flash error message indicating the image could not be prefetched' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to eq(["Offences aren't available right now, please try again or fill in the offences below"])
      end
    end
    
    context 'when image for the detainee cannot be found' do
      before do
        stub_nomis_api_request(:get, nomis_image_path, body: { image: nil }.to_json)
      end

      it 'sets a flash error message indicating the image was not found' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to eq(['Look-Up function for photograph returned no image. Either try again later or attach photograph manually to print out'])
      end
    end
    
    context 'when the provided prison number is invalid' do
      before do
        stub_nomis_api_request(:get, nomis_detainee_path, status: 400)
        stub_nomis_api_request(:get, nomis_image_path, status: 400)
        stub_nomis_api_request(:get, nomis_offences_path, status: 400)
      end

      it 'sets a flash error message indicating the provided prison number is invalid' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to include('The provided prison number is not valid, please try again with a valid prison number')
      end
    end

    context 'when there are no records for the provided prison number' do
      let(:body) { [].to_json }

      before do
        stub_nomis_api_request(:get, nomis_detainee_path, status: 404)
        stub_nomis_api_request(:get, nomis_image_path, status: 404)
      end

      it 'sets a flash error message indicating there no records in the API for the provided prison number' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to include('No record for that prison reference exists. Please check the reference used or enter the details manually')
      end
    end

    context 'when image for the detainee cannot be found' do
      before do
        stub_nomis_api_request(:get, nomis_detainee_path)
        stub_nomis_api_request(:get, nomis_image_path, body: { image: nil }.to_json)
      end

      it 'sets a flash error message indicating the image was not found' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to include('Look-Up function for photograph returned no image. Either try again later or attach photograph manually to print out')
      end
    end

    context 'when details api returns invalid json' do
      let(:body) { 'not-valid-json' }

      before do
        stub_nomis_api_request(:get, nomis_detainee_path, body: body)
        stub_nomis_api_request(:get, nomis_image_path)
      end

      it 'sets a flash error message indicating the details could not be prefetched' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to include('Look-Up function is not currently available. Please enter person details manually or try again later')
      end
    end

    context 'when image api returns invalid json' do
      let(:body) { 'not-valid-json' }

      before do
        stub_nomis_api_request(:get, nomis_detainee_path)
        stub_nomis_api_request(:get, nomis_image_path, body: body)
      end

      it 'sets a flash error message indicating the image could not be prefetched' do
        post '/escorts', params: { escort: { prison_number: prison_number } }
        expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
      end
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
