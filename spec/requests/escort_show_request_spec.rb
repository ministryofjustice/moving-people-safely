require 'rails_helper'

RSpec.describe 'PER page requests', type: :request do
  let(:prison_number) { 'A45345HG' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:move) { create(:move) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

  describe "#show" do
    context 'when user is not authorized' do
      it 'redirects user to login page' do
        get "/escorts/#{escort.id}"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_session_path
      end
    end

    context 'when user is authorized' do
      before { sign_in(create(:user)) }

      context 'when the escort for the provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            get "/escorts/#{SecureRandom.uuid}"
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the escort has no detainee details' do
        let(:escort) { create(:escort) }

        it 'redirects to the new detainee page' do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(302)
          expect(response).to redirect_to new_escort_detainee_path(escort)
        end
      end

      context 'when the escort has no detainee details' do
        let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }

        it 'redirects to the new move page' do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(302)
          expect(response).to redirect_to new_escort_move_path(escort)
        end
      end

      context "with a valid escort ID" do
        it "responds with 200" do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
