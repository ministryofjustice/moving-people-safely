require 'rails_helper'

RSpec.describe 'PER page requests', type: :request do
  let(:detainee) { create(:detainee) }
  let(:escort) { create(:escort, detainee: detainee) }

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

      context "with a valid escort ID" do
        it "responds with 200" do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
