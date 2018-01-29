require 'rails_helper'

RSpec.describe 'Offences', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:move) { create(:move) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }
  let(:offences) { escort.offences }
  let(:form_data) {
    {
      offences: {
        offences_attributes: {
          "0" => {
            id: "some-uuid",
            offence: "some offence",
            case_reference: "1234LOL",
            _delete: "0"
          }
        }
      }
    }
  }

  describe "when not logged in" do
    it "get #show redirects to /sign_in" do
      get "/escorts/#{escort.id}/offences"
      expect(response).to redirect_to new_session_path
    end

    it "patch #update redirects to /sign_in" do
      patch "/escorts/#{escort.id}/offences", params: form_data
      expect(response).to redirect_to new_session_path
    end

    it "put #update redirects to /sign_in" do
      put "/escorts/#{escort.id}/offences", params: form_data
      expect(response).to redirect_to new_session_path
    end
  end

  context "while logged in" do
    before { sign_in create(:user) }

    describe "#show" do
      context 'but the escort with provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            get "/escorts/#{SecureRandom.uuid}/offences"
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'but the escort is no longer editable' do
        let(:escort) { create(:escort, :issued) }

        it 'still displays the offences page' do
          get "/escorts/#{escort.id}/offences"
          expect(response).to have_http_status(200)
        end
      end

      it "returns a 200 code" do
        allow(Nomis::Api.instance).to receive(:get)
        get "/escorts/#{escort.id}/offences"
        expect(response).to have_http_status(200)
      end
    end

    describe "#update" do
      context 'but the escort with provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            put "/escorts/#{SecureRandom.uuid}/offences", params: form_data
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'but the escort is no longer editable' do
        let(:escort) { create(:escort, :issued) }

        it 'redirects to the homepage displaying an appropriate error' do
          put "/escorts/#{escort.id}/offences", params: form_data
          expect(flash[:alert]).to eq('The PER can no longer be changed.')
          expect(response).to have_http_status(302)
        end
      end

      context "with validating data" do
        it "redirects to the PER page" do
          put "/escorts/#{escort.id}/offences", params: form_data
          expect(response).to have_http_status(302)
          expect(response).to redirect_to "/escorts/#{escort.id}"
        end
      end

      context "posted data fails validation" do
        let(:invalid_offence) { { "id"=>"", "offence"=>"" } }
          let(:form_data) { { offences: { offences_attributes: { '0' => invalid_offence } } } }

        it "redirects to #show" do
          put "/escorts/#{escort.id}/offences", params: form_data
          expect(response).to redirect_to "/escorts/#{escort.id}/offences"
        end
      end
    end
  end
end
