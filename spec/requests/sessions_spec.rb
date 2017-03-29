require 'rails_helper'

RSpec.describe 'session expire', type: :request do

  context "with a valid session" do
    before { sign_in create(:user) }

    it "responds with 200" do
      get '/'
      expect(response).to have_http_status(200)
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
