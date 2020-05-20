# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nomis::Client do
  subject(:client) { described_class.new(host, client_id, client_secret, options) }

  let(:host) { 'http://example.com' }
  let(:client_id) { 'foo' }
  let(:client_secret) { 'bar' }
  let(:options) { {} }

  describe '#http_error_body' do
    context 'when the response body is parseable JSON' do
      let(:body) { '{}' }

      it 'returns the error body' do
        expect(client.http_error_body(body)).to eq({})
      end
    end

    context 'when the response body is unparseable' do
      let(:body) { '<h1></h1>' }

      it 'returns a subset of the full html to the caller' do
        expect(client.http_error_body(body)).to eq('(invalid-JSON) <h1></h1>')
      end
    end
  end
end
