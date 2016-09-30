require 'rails_helper'

RSpec.describe 'Offences', type: :request do
  let(:detainee) { create(:detainee) }
  let(:form_data) { FixtureData.consideration(:offences) }

  describe "when not logged in" do
    it "get #show redirects to /sign_in" do
      get "/#{detainee.id}/offences"
      expect(response).to redirect_to new_user_session_path
    end

    it "patch #update redirects to /sign_in" do
      patch "/#{detainee.id}/offences", params: form_data
      expect(response).to redirect_to new_user_session_path
    end

    it "put #update redirects to /sign_in" do
      put "/#{detainee.id}/offences", params: form_data
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "while logged in" do
    before { sign_in FactoryGirl.create(:user) }
    let(:detainee) { create(:detainee, :with_active_move) }

    describe "#show" do
      before { get "/#{detainee.id}/offences" }

      it "returns a 200 code" do
        expect(response.status).to eql 200
      end
    end

    describe "#update" do
      before { put "/#{detainee.id}/offences", params: form_data }

      context "with validating data" do
        it "redirects to the move overview" do
          expect(response.status).to eql 302
          expect(response).to redirect_to "/#{detainee.active_move.id}/profile"
        end
      end

      context "posted data fails validation" do
        let(:form_data) do
          FixtureData.consideration(:offences).merge ({
            release_date: { date: 'not a real date' }
          })
        end

        it "redirects to #show" do
          expect(response).to redirect_to "/#{detainee.id}/offences"
        end
      end
    end
  end
end
