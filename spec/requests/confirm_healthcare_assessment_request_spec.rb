require 'rails_helper'

RSpec.describe 'Confirm healthcare assessment requests', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:healthcare) { create(:healthcare) }
  let(:escort) { create(:escort, prison_number: prison_number, healthcare: healthcare) }

  context 'when user is not autenticated' do
    it 'redirects the user to the login page' do
      put "/escorts/#{escort.id}/healthcare/confirm"
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'when user is autenticated' do
    before { sign_in create(:user) }

    context 'but the escort with provided id does not exist' do
      it 'raises a record not found error' do
        expect {
          put "/escorts/#{SecureRandom.uuid}/healthcare/confirm"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'but the escort is no longer editable' do
      let(:healthcare) { create(:healthcare) }
      let(:move) { create(:move) }
      let(:detainee) { create(:detainee) }
      let(:escort) { create(:escort, :issued, healthcare: healthcare) }

      it 'redirects to the homepage displaying an appropriate error' do
        put "/escorts/#{escort.id}/healthcare/confirm"
        expect(flash[:alert]).to eq('The PER can no longer be changed.')
        expect(response).to have_http_status(302)
      end
    end

    context 'and the healthcare assessment is not yet complete' do
      let(:detainee) { create(:detainee) }
      let(:move) { create(:move) }
      let(:escort) { create(:escort, :with_incomplete_healthcare_assessment) }

      it 'sets a flash error' do
        put "/escorts/#{escort.id}/healthcare/confirm"
        expect(response).to have_http_status(200)
        expect(flash[:error]).to eq('Healthcare assessment cannot be confirmed until all mandatory answers are filled')
      end

      it 'does not change the state of the healthcare assessment' do
        expect {
          put "/escorts/#{escort.id}/healthcare/confirm"
        }.not_to change { escort.healthcare.reload.status }.from('incomplete')
      end
    end

    context 'and the healthcare assessment is unconfirmed' do
      let(:healthcare) { create(:healthcare, :unconfirmed) }
      let(:escort) { create(:escort, healthcare: healthcare) }

      it 'redirects to the PER page' do
        put "/escorts/#{escort.id}/healthcare/confirm"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(escort_path(escort))
      end

      it 'marks healthcare assessment as confirmed' do
        expect {
          put "/escorts/#{escort.id}/healthcare/confirm"
        }.to change { healthcare.reload.status }.from('unconfirmed').to('confirmed')
      end
    end
  end
end
