require 'rails_helper'

RSpec.describe 'Offences', type: :request do
  let(:escort) { FactoryGirl.create :escort }
  let(:form_data) { { offences: escort.offences.attributes } }

  describe "when not logged in" do
    it "get #show redirects to /sign_in" do
      get "/#{escort.id}/offences"
      expect(response).to redirect_to new_user_session_path
    end

    it "patch #update redirects to /sign_in" do
      patch "/#{escort.id}/offences", params: form_data
      expect(response).to redirect_to new_user_session_path
    end

    it "put #update redirects to /sign_in" do
      put "/#{escort.id}/offences", params: form_data
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "while logged in" do
    before { sign_in FactoryGirl.create(:user) }

    describe "#show" do
      before { get "/#{escort.id}/offences" }

      it "returns a 200 code" do
        expect(response.status).to eql 200
      end
    end

    describe "#update" do
      before { put "/#{escort.id}/offences", params: form_data }

      context "with validating data" do
        it "redirects to the prisoner's profile" do
          expect(response.status).to eql 302
          expect(response).to redirect_to "/#{escort.id}/profile"
        end
      end

      context "posted data fails validation" do
        let(:form_data) { { offences: { release_date: 'not a real date' } } }

        it "redirects to #show" do
          expect(response).to redirect_to "/#{escort.id}/offences"
        end
      end
    end
  end
end