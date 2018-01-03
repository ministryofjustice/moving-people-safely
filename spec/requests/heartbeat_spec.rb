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
    let(:sso_url) { Rails.application.config.x.moj_sso_url }
    let(:response_hash) { JSON.parse(response.body) }
    let(:database_status) { response_hash['checks']['database'] }
    let(:sso_status) { response_hash['checks']['moj-sign-on'] }
    let(:health_status) { response_hash['healthy'] }

    shared_context :sso_working do
      before do
        stub_request(:get, sso_url).to_return(status: 200)
        get '/healthcheck.json'
      end
    end
    
    shared_context :sso_not_working do
      before do
        stub_request(:get, sso_url).to_return(status: 500)
        get '/healthcheck.json'
      end
    end
    
    shared_examples 'database' do |expected| 
      it "indicates database #{expected}" do
        expect(database_status).to eq(expected == 'OK')
      end
    end
    
    shared_examples 'SSO' do |expected| 
      it "indicates SSO #{expected}" do
        expect(sso_status).to eq(expected == 'OK')
      end
    end
    
    shared_examples 'overall health' do |expected| 
      it "indicates overall health #{expected}" do
        expect(health_status).to eq(expected == 'OK')
      end
    end
    
    context 'database connection' do
      context 'working' do
        context 'single sign on' do
          context 'is working' do
            include_context :sso_working

            it_behaves_like 'database', 'OK'
            it_behaves_like 'SSO', 'OK'
            it_behaves_like 'overall health', 'OK'
          end

          context 'is not working' do
            include_context :sso_not_working

            it_behaves_like 'database', 'OK'
            it_behaves_like 'SSO', 'not OK'
            it_behaves_like 'overall health', 'not OK'
          end
        end
      end
        
      context 'not working' do
        before do
          expect(ActiveRecord::Base.connection).to receive(:active?).
            and_return(false)
        end

        context 'single sign on' do
          context 'is working' do
            include_context :sso_working

            it_behaves_like 'database', 'not OK'
            it_behaves_like 'SSO', 'OK'
            it_behaves_like 'overall health', 'not OK'
          end

          context 'is not working' do
            include_context :sso_not_working

            it_behaves_like 'database', 'not OK'
            it_behaves_like 'SSO', 'not OK'
            it_behaves_like 'overall health', 'not OK'
          end
        end
      end
    end
  end
end
