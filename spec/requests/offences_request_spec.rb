require 'rails_helper'

RSpec.describe 'Offences', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:move) { create(:move, :active) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }
  let(:offences) { escort.offences }
  let(:form_data) { { offences: offences.attributes } }

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
        let(:move) { create(:move, :issued) }
        let(:escort) { create(:escort, detainee: detainee, move: move) }

        it 'still displays the offences page' do
          get "/escorts/#{escort.id}/offences"
          expect(response).to have_http_status(200)
        end
      end

      context 'but there is no offences to show yet' do
        let(:escort) { create(:escort) }

        it 'raises a record not found error' do
          expect {
            get "/escorts/#{escort.id}/offences"
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'and there are no offences associated with the detainee' do
        let(:detainee) { create(:detainee, :with_no_offences, prison_number: prison_number) }
        let(:move) { create(:move) }
        let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

        it "calls the NOMIS API" do
          expect(Nomis::Api.instance).
            to receive(:get).with("/offenders/#{detainee.prison_number}/charges")

          get "/escorts/#{escort.id}/offences"
        end

        context "when the NOMIS API is unavailable" do
          before do
            stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", status: 500)
          end

          it 'sets a flash error message indicating the image could not be prefetched' do
            get "/escorts/#{escort.id}/offences"

            expect(flash[:warning]).
              to include("Offences aren't available right now, please try again or fill in the offences below")
          end
        end
      end

      it "returns a 200 code" do
        get "/escorts/#{escort.id}/offences"
        expect(response).to have_http_status(200)
      end

      it "does not call the NOMIS API" do
        expect(Nomis::Api.instance).not_to receive(:get)
        get "/escorts/#{escort.id}/offences"
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
        let(:move) { create(:move, :issued) }
        let(:escort) { create(:escort, detainee: detainee, move: move) }

        it 'redirects to the homepage displaying an appropriate error' do
          put "/escorts/#{escort.id}/offences", params: form_data
          expect(flash[:alert]).to eq('The PER can no longer be changed.')
          expect(response).to have_http_status(302)
        end
      end

      context 'but there is no offences to show yet' do
        let(:escort) { create(:escort) }
        let(:form_data) { { offences: build(:offences).attributes } }

        it 'raises a record not found error' do
          expect {
            put "/escorts/#{escort.id}/offences", params: form_data
          }.to raise_error(ActiveRecord::RecordNotFound)
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
        let(:invalid_current_offence) { { "id"=>"", "offence"=>"" } }
        let(:form_data) { { offences: { current_offences_attributes: { '0' => invalid_current_offence } } } }

        it "redirects to #show" do
          put "/escorts/#{escort.id}/offences", params: form_data
          expect(response).to redirect_to "/escorts/#{escort.id}/offences"
        end
      end
    end
  end
end
