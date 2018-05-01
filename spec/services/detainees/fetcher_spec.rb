require 'rails_helper'

RSpec.describe Detainees::Fetcher do
  let(:options) { {} }
  let(:prison_number) { 'A1234Ab' }
  let(:nomis_details) { { surname: 'Doe' }.to_json }
  let(:nomis_image) { { image: 'base-64-encoded' }.to_json }
  let(:mock_details_fetcher) { instance_double(Detainees::DetailsFetcher) }
  let(:mock_image_fetcher) { instance_double(Detainees::ImageFetcher) }
  let(:mock_peep_fetcher) { instance_double(Detainees::PeepFetcher) }
  let(:details_hash) { { details: 'mocked-details' } }
  let(:details_error) { nil }
  let(:image_hash) { { image: 'mocked-image' } }
  let(:image_error) { nil }
  let(:peep_hash) { { peep: 'yes', peep_details: 'broken leg' } }
  let(:peep_error) { nil }
  let(:mock_details_response) {
    instance_double(Detainees::FetcherResponse, to_h: details_hash, error: details_error)
  }
  let(:mock_image_response) {
    instance_double(Detainees::FetcherResponse, to_h: image_hash, error: image_error)
  }
  let(:mock_peep_response) {
    instance_double(Detainees::FetcherResponse, to_h: peep_hash, error: peep_error)
  }

  subject(:fetcher) { described_class.new(prison_number, options) }

  before do
    allow(Detainees::DetailsFetcher).to receive(:new).and_return(mock_details_fetcher)
    allow(mock_details_fetcher).to receive(:call).and_return(mock_details_response)
    allow(Detainees::ImageFetcher).to receive(:new).and_return(mock_image_fetcher)
    allow(mock_image_fetcher).to receive(:call).and_return(mock_image_response)
    allow(Detainees::PeepFetcher).to receive(:new).and_return(mock_peep_fetcher)
    allow(mock_peep_fetcher).to receive(:call).and_return(mock_peep_response)
  end

  shared_examples_for 'detainee details service called' do
    it 'fetches the detainee details using an upcased prison number' do
      expect(Detainees::DetailsFetcher).to receive(:new).with(prison_number.upcase)
      fetcher.call
    end
  end

  shared_examples_for 'detainee image service called' do
    it 'fetches the image details using an upcased prison number' do
      expect(Detainees::ImageFetcher).to receive(:new).with(prison_number.upcase)
      fetcher.call
    end
  end

  shared_examples_for 'detainee peep service called' do
    it 'fetches the image details using an upcased prison number' do
      expect(Detainees::PeepFetcher).to receive(:new).with(prison_number.upcase)
      fetcher.call
    end
  end

  shared_examples_for 'all services retrieved' do
    include_examples 'detainee details service called'
    include_examples 'detainee image service called'
    include_examples 'detainee peep service called'

    it 'retrieves details, peep and image for the detainee' do
      response = fetcher.call
      expect(response.to_h).to eq({ details: 'mocked-details', image: 'mocked-image', peep: 'yes', peep_details: 'broken leg' })
    end

    context 'when the details information does not exist or provided prison number is invalid' do
      let(:details_error) { 'not_found' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to eq({})
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to include('details.not_found')
      end
    end

    context 'when the details information cannot be retrieved' do
      let(:details_error) { 'api_error' }

      it 'returns only the image and peep for the detainee' do
        response = fetcher.call
        expect(response.to_h).to eq({ image: 'mocked-image', peep: 'yes', peep_details: 'broken leg' })
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to include('details.unavailable')
      end
    end

    context 'when the image cannot be retrieved' do
      let(:image_error) { 'api_error' }

      it 'returns only the detailsand peep for the detainee' do
        response = fetcher.call
        expect(response.to_h).to eq({ details: 'mocked-details', peep: 'yes', peep_details: 'broken leg' })
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to include('image.unavailable')
      end
    end

    context 'when there is no records for the provided prison number' do
      let(:details_error) { 'not_found' }
      let(:image_error) { 'api_error' }
      let(:peep_error) { 'api_error' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to be_empty
      end

      it 'returns the list of errors that occured for each service' do
        response = fetcher.call
        expect(response.errors).to match_array(%w[details.not_found])
      end
    end

    context 'when neither peep, details or image can be retrieved' do
      let(:details_error) { 'invalid_input' }
      let(:image_error) { 'api_error' }
      let(:peep_error) { 'api_error' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to be_empty
      end

      it 'returns the list of errors that occured for each service' do
        response = fetcher.call
        expect(response.errors).to match_array(%w[details.invalid_input image.unavailable peep.unavailable])
      end
    end
  end

  context 'when no options are supplied' do
    let(:options) { {} }
    include_examples 'all services retrieved'
  end
end
