require 'rails_helper'

RSpec.describe 'Offences', type: :request do
  let(:detainee) { create(:detainee) }
  let(:form_data) { { offences: detainee.offences.attributes } }

  describe "when not logged in" do
    it "get #show redirects to /sign_in" do
      get "/#{detainee.id}/offences"
      expect(response).to redirect_to new_session_path
    end

    it "patch #update redirects to /sign_in" do
      patch "/#{detainee.id}/offences", params: form_data
      expect(response).to redirect_to new_session_path
    end

    it "put #update redirects to /sign_in" do
      put "/#{detainee.id}/offences", params: form_data
      expect(response).to redirect_to new_session_path
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
        it "redirects to the detainee's profile" do
          expect(response.status).to eql 302
          expect(response).to redirect_to "/detainees/#{detainee.id}"
        end
      end

      context "posted data fails validation" do
        let(:invalid_current_offence) { { "id"=>"", "offence"=>"" } }
        let(:form_data) { { offences: { current_offences_attributes: { '0' => invalid_current_offence } } } }

        it "redirects to #show" do
          expect(response).to redirect_to "/#{detainee.id}/offences"
        end
      end
    end
  end
end
