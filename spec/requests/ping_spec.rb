require 'rails_helper'

RSpec.describe 'Pings', type: :request do
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
        get '/ping'

        expect(response.body).to eq(
          {
            build_date: '2017-04-06T14:47:13+0000',
            build_tag: 'branch-name.partial-sha',
            commit: 'some-sha-from-git'
          }.to_json
        )
      end
    end

    context 'when the environment variables are not present' do
      it 'returns an empty json object' do
        get '/ping'

        expect(response.body).to eq({}.to_json)
      end
    end
  end
end
