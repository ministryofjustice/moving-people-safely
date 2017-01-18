require 'rails_helper'

RSpec.describe 'Confirm risk assessment requests', type: :request do
  let(:detainee) { FactoryGirl.create(:detainee) }

  context 'when user is not autenticated' do
    it 'redirects the user to the login page' do
      put "/#{detainee.id}/risk/confirm"
      expect(response.status).to eq(302)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is autenticated' do
    before { sign_in FactoryGirl.create(:user) }

    context 'but there is no active move' do
      before do
        FactoryGirl.create(:move, :issued, detainee: detainee)
      end

      it 'redirects the user to the login page' do
        put "/#{detainee.id}/risk/confirm"
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'and the risk assessment is not yet complete' do
      let(:detainee) { FactoryGirl.create(:detainee, :with_incomplete_risk_assessment) }
      let(:create_move) { FactoryGirl.create(:move, :with_incomplete_risk_workflow, detainee: detainee) }
      let(:risk_workflow) { create_move.risk_workflow }

      before { create_move }

      it 'sets a flash error' do
        put "/#{detainee.id}/risk/confirm"
        expect(response.status).to eq(200)
        expect(flash[:error]).to eq('Risk assessment cannot be confirmed until all mandatory answered are filled')
      end

      it 'does not change the state of the risk workflow' do
        expect {
          put "/#{detainee.id}/risk/confirm"
        }.not_to change { risk_workflow.reload.status }.from('incomplete')
      end
    end

    context 'and the risk assessment is complete' do
      let(:create_move) { FactoryGirl.create(:move, :with_incomplete_risk_workflow, detainee: detainee) }
      alias move create_move
      let(:risk_workflow) { move.risk_workflow }

      before { create_move }

      it 'redirects to the profile page' do
        put "/#{detainee.id}/risk/confirm"
        expect(response.status).to eq(302)
        expect(response).to redirect_to(detainee_path(detainee))
      end

      it 'marks risk workflow as confirmed' do
        expect {
          put "/#{detainee.id}/risk/confirm"
        }.to change { risk_workflow.reload.status }.from('incomplete').to('confirmed')
      end
    end
  end
end
