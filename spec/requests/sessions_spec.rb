require 'rails_helper'

RSpec.describe 'session expire', type: :request do

  context "with a valid session" do
    context 'and a live token from SSO' do
      before { sign_in create(:user) }

      it "responds with 200" do
        get '/'
        expect(response).to have_http_status(200)
      end
    end

    context 'and an expired token from SSO' do
      let(:sso_config) do
        { 
          sso: {
            info: { permissions: [{'organisation' => 'digital.noms.moj'}]},
            credentials: { expires_at: Time.now.to_i - 4000 }   
          }
        }
      end

      before { sign_in create(:user), sso_config }

      it "redirect to the new session page" do
        get '/'
        expect(response).to have_http_status(302).and redirect_to('/session/new')
      end
    end
  end

  context "with an expired session" do
    before do
      travel_to(1.hour.ago) do
        sign_in create(:user)
      end
    end

    it "redirect to the new session page" do
      get '/'
      expect(response).to have_http_status(302).and redirect_to('/session/new')
    end
  end
end
