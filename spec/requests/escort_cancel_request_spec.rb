require 'rails_helper'

RSpec.describe 'PER page requests', type: :request do
  let(:prison_number) { 'A45345HG' }
  let(:escort) { create(:escort, prison_number: prison_number) }
  let(:params) { { escort: { cancelling_reason: 'initiated by mistake' } } }

  describe "#cancel" do
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
            put "/escorts/#{SecureRandom.uuid}/cancel", params: params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when the escort has already been issued" do
        let(:escort) { create(:escort, :issued, prison_number: prison_number) }

        it 'cancel the escort and redirect to the dashboard page' do
          put "/escorts/#{escort.id}/cancel", params: params
          expect(escort.reload).to be_cancelled
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end

      context "with a valid escort ID" do
        it "redirects to the dashboard page" do
          put "/escorts/#{escort.id}/cancel", params: params
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
