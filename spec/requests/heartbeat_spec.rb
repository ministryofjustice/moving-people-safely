require 'rails_helper'

RSpec.describe 'Heartbeat', type: :request do
  describe 'GET /ping' do
    context 'when the correct environment variables have been set during the deploy process' do
      around do |example|
        ClimateControl.modify(
          'APP_BUILD_DATE' => '2017-04-06T14:47:13+0000',
          'APP_BUILD_TAG' => 'branch-name.partial-sha',
          'APP_GIT_COMMIT' => 'some-sha-from-git'
        ) do
          example.run
        end
      end

      it 'returns json containing the applications version information' do
        get '/ping.json'

        expect(response.body).to eq(
          {
            build_date: '2017-04-06T14:47:13+0000',
            commit_id: 'some-sha-from-git',
            build_tag: 'branch-name.partial-sha'
          }.to_json
        )
        expect(response.code).to eq '200'
      end
    end

    context 'when the environment variables are not present' do
      it 'returns an empty json object' do
        get '/ping'

        expect(response.body).to eq(
          {
            build_date: 'Not Available',
            commit_id: 'Not Available',
            build_tag: 'Not Available'
          }.to_json
        )
        expect(response.code).to eq '200'
      end
    end
  end

  describe 'GET /healthcheck' do
    context 'when the database connection works' do
      it 'returns json containing the checks' do
        get '/healthcheck.json'

        expect(response.body).to eq(
          {
            checks: {
              database: true
            }
          }.to_json
        )
        expect(response.code).to eq '200'
      end
    end

    context 'when the database connection does not work' do
      before { expect(ActiveRecord::Base.connection).to receive(:active?).and_return(false) }

      it 'returns json containing the checks' do
        get '/healthcheck.json'

        expect(response.body).to eq(
          {
            checks: {
              database: false
            }
          }.to_json
        )
        expect(response.code).to eq '502'
      end
    end
  end

end
