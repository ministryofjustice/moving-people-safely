require 'rails_helper'

RSpec.describe 'banner if IE8', type: :request do
  before { get '/session/new', headers: { HTTP_USER_AGENT: user_agent_string } }

  let(:banner_text_regex) do
    /This service will stop supporting this version of Internet Explorer soon/
  end

  context 'using IE8' do
    let(:user_agent_string) do
      'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; GTB7.4; InfoPath.2; SV1; .NET CLR 3.3.69573; WOW64; en-US)'
    end

    it 'shows warning banner' do
      expect(response.body).to match banner_text_regex
    end
  end

  context 'using Chrome' do
    let(:user_agent_string) do
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'
    end

    it 'shows no warning banner' do
      expect(response.body).not_to match banner_text_regex
    end
  end
end
