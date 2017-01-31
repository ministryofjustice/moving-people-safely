require 'rails_helper'

RSpec.describe Detainees::Fetcher do
  let(:options) { {} }
  let(:prison_number) { 'A1234AB' }
  let(:nomis_details) { { surname: 'Doe' }.to_json }
  let(:nomis_image) { { image: 'base-64-encoded' }.to_json }
  let(:mock_details_fetcher) { instance_double(Detainees::DetailsFetcher) }
  let(:mock_image_fetcher) { instance_double(Detainees::ImageFetcher) }
  let(:details_hash) { { details: 'mocked-details' } }
  let(:details_error) { nil }
  let(:image_hash) { { image: 'mocked-image' } }
  let(:image_error) { nil }
  let(:mock_details_response) {
    instance_double(Detainees::FetcherResponse, to_h: details_hash, error: details_error)
  }
  let(:mock_image_response) {
    instance_double(Detainees::FetcherResponse, to_h: image_hash, error: image_error)
  }

  subject(:fetcher) { described_class.new(prison_number, options) }

  before do
    allow(Detainees::DetailsFetcher).to receive(:new).and_return(mock_details_fetcher)
    allow(mock_details_fetcher).to receive(:call).and_return(mock_details_response)
    allow(Detainees::ImageFetcher).to receive(:new).and_return(mock_image_fetcher)
    allow(mock_image_fetcher).to receive(:call).and_return(mock_image_response)
  end

  shared_examples_for 'all services retrieved' do
    it 'retrieves both details and image for the detainee' do
      response = fetcher.call
      expect(response.to_h).to eq({ details: 'mocked-details', image: 'mocked-image' })
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

      it 'returns only the image for the detainee' do
        response = fetcher.call
        expect(response.to_h).to eq({ image: 'mocked-image' })
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to include('details.unavailable')
      end
    end

    context 'when the image cannot be retrieved' do
      let(:image_error) { 'api_error' }

      it 'returns only the details for the detainee' do
        response = fetcher.call
        expect(response.to_h).to eq({ details: 'mocked-details' })
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to include('image.unavailable')
      end
    end

    context 'when there is no records for the provided prison number' do
      let(:details_error) { 'not_found' }
      let(:image_error) { 'api_error' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to be_empty
      end

      it 'returns the list of errors that occured for each service' do
        response = fetcher.call
        expect(response.errors).to match_array(%w[details.not_found])
      end
    end

    context 'when neither details or image can be retrieved' do
      let(:details_error) { 'invalid_input' }
      let(:image_error) { 'api_error' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to be_empty
      end

      it 'returns the list of errors that occured for each service' do
        response = fetcher.call
        expect(response.errors).to match_array(%w[details.invalid_input image.unavailable])
      end
    end
  end

  context 'when no options are supplied' do
    let(:options) { {} }
    include_examples 'all services retrieved'
  end

  context 'when pull option is :all' do
    let(:options) { { pull: :all } }
    include_examples 'all services retrieved'
  end

  context 'when pull option is :details' do
    let(:options) { { pull: :details } }

    it 'retrieves only the details for the detainee' do
      response = fetcher.call
      expect(response.to_h).to eq({ details: 'mocked-details' })
    end

    context 'when the details information cannot be retrieved' do
      let(:details_error) { 'not_found' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to be_empty
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to match_array(%w[details.not_found])
      end
    end
  end

  context 'when pull option is :image' do
    let(:options) { { pull: :image } }

    it 'retrieves only the image for the detainee' do
      response = fetcher.call
      expect(response.to_h).to eq({ image: 'mocked-image' })
    end

    context 'when the image cannot be retrieved' do
      let(:image_error) { 'api_error' }

      it 'returns an empty hash' do
        response = fetcher.call
        expect(response.to_h).to be_empty
      end

      it 'returns a response containing the error that occured' do
        response = fetcher.call
        expect(response.errors).to match_array(%w[image.unavailable])
      end
    end
  end

  context 'when pull option is other than the valid options' do
    let(:options) { { pull: :other } }

    it 'does not retrieve any information for the detainee' do
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.errors).to be_empty
    end
  end
end
