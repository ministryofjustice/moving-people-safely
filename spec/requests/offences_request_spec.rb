require 'rails_helper'

RSpec.describe 'Offences requests', type: :request do
  let(:escort) { Escort.create }

  describe "when not logged in" do
    it "get #show redirects to /sign_in" do
      get "/#{escort.id}/offences"
      expect(response).to redirect_to new_user_session_path
    end

    it "patch #update redirects to /sign_in" do
      patch "/#{escort.id}/offences", params: escort.offences.to_param
      expect(response).to redirect_to new_user_session_path
    end

    it "put #update redirects to /sign_in" do
      put "/#{escort.id}/offences", params: escort.offences.to_param
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "while logged in" do
    before { sign_in User.new }

    describe "#show" do
      it "returns a 200 code" do
        get "/#{escort.id}/offences"
        expect(response.status).to eql 200
      end
    end
  end
end