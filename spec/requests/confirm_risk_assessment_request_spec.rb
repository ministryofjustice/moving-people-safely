require 'rails_helper'

RSpec.describe 'Confirm risk assessment requests', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }

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

    context 'but the escort is no longer editable' do
      let(:move) { create(:move, :issued) }
      let(:escort) { create(:escort, move: move) }

      it 'redirects to the homepage displaying an appropriate error' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(flash[:alert]).to eq('The PER can no longer be changed.')
        expect(response).to have_http_status(302)
      end
    end

    context 'but there is no risk assessment to confirm' do
      let(:escort) { create(:escort) }

      it 'raises a record not found error' do
        expect {
          put "/escorts/#{escort.id}/risk/confirm"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'and the risk assessment is not yet complete' do
      let(:detainee) { create(:detainee, :with_incomplete_risk_assessment) }
      let(:move) { create(:move, :with_incomplete_risk_workflow) }
      let(:risk_workflow) { move.risk_workflow }
      let(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'sets a flash error' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(response).to have_http_status(200)
        expect(flash[:error]).to eq('Risk assessment cannot be confirmed until all mandatory answered are filled')
      end

      it 'does not change the state of the risk workflow' do
        expect {
          put "/escorts/#{escort.id}/risk/confirm"
        }.not_to change { risk_workflow.reload.status }.from('incomplete')
      end
    end

    context 'and the risk assessment is complete' do
      let(:escort) { create(:escort, detainee: detainee, move: move) }
      let(:move) { create(:move, :with_incomplete_risk_workflow) }
      let(:risk_workflow) { move.risk_workflow }

      it 'redirects to the PER page' do
        put "/escorts/#{escort.id}/risk/confirm"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(escort_path(escort))
      end

      it 'marks risk workflow as confirmed' do
        expect {
          put "/escorts/#{escort.id}/risk/confirm"
        }.to change { risk_workflow.reload.status }.from('incomplete').to('confirmed')
      end
    end
  end
end
