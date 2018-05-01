require 'rails_helper'

RSpec.describe 'Confirm risk assessment requests', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:risk) { create(:risk) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, risk: risk) }

  context 'when user is not autenticated' do
    it 'redirects the user to the login page' do
      put "/escorts/#{escort.id}/risk/confirm"
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'when user is autenticated' do
    before { sign_in create(:user) }

    context 'but the escort with provided id does not exist' do
      it 'raises a record not found error' do
        expect {
          put "/escorts/#{SecureRandom.uuid}/risk/confirm"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'but there is no detainee details for the PER' do
      let(:escort) { create(:escort) }

      it 'redirects the user back to the escort page' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(escort_path(escort))
      end
    end

    context 'but the escort is no longer editable' do
      let(:escort) { create(:escort, :issued) }

      it 'redirects to the homepage displaying an appropriate error' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(flash[:alert]).to eq('The PER can no longer be changed.')
        expect(response).to have_http_status(302)
      end
    end

    context 'and the risk assessment is not yet complete' do
      let(:detainee) { create(:detainee) }
      let(:move) { create(:move) }
      let(:escort) { create(:escort, :with_incomplete_risk_assessment, detainee: detainee, move: move) }

      it 'sets a flash error' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(response).to have_http_status(200)
        expect(flash[:error]).to eq('Risk assessment cannot be confirmed until all mandatory answers are filled')
      end

      it 'does not change the state of the risk assessment' do
        expect {
          put "/escorts/#{escort.id}/risk/confirm"
        }.not_to change { escort.risk.reload.status }.from('incomplete')
      end
    end

    context 'and the risk assessment is unconfirmed' do
      let(:risk) { create(:risk, :unconfirmed) }
      let(:escort) { create(:escort, :with_detainee, :with_move, risk: risk) }

      it 'redirects to the PER page' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(escort_path(escort))
      end

      it 'marks risk assessment as confirmed' do
        expect {
          put "/escorts/#{escort.id}/risk/confirm"
        }.to change { risk.reload.status }.from('unconfirmed').to('confirmed')
      end
    end
  end
end
