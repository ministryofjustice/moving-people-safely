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
      let(:permissions) { { sso: { info: { permissions: [{'organisation' => 'digital.noms.moj'}]}}} }

      before { sign_in(create(:user), permissions) }

      context 'when the escort for the provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            get "/escorts/#{SecureRandom.uuid}"
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the escort has no detainee details' do
        let(:move) { create(:move) }
        let(:escort) { create(:escort, move: move) }

        it 'redirects to the new detainee page' do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(302)
          expect(response).to redirect_to new_escort_detainee_path(escort)
        end
      end

      context 'when the escort has no filled moved details' do
        let(:move) { create(:move, to: '') }
        let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

        it 'redirects to the new move page' do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(302)
          expect(response).to redirect_to edit_escort_move_path(escort)
        end
      end

      context "with a valid escort ID" do
        before { get "/escorts/#{escort.id}" }

        it "responds with 200" do
          expect(response).to have_http_status(200)
        end

        it 'no audit created' do
          expect(escort.audits.count).to eq(0)
        end

        context 'for an issued escort' do
          let(:escort) { create(:escort, :issued, prison_number: prison_number, detainee: detainee, move: move) }

          it 'audit created' do
            expect(escort.audits.count).to eq(1)
          end
        end
      end

      context 'when the escort and the user belong to the same establishment' do
        let(:bedford_sso_id) { 'bedford.prisons.noms.moj' }
        let(:bedford_nomis_id) { 'BDI' }
        let(:bedford) { create(:prison, name: 'HMP Bedford', sso_id: bedford_sso_id, nomis_id: bedford_nomis_id) }
        let(:escort) { create(:escort, :completed, move: create(:move, from_establishment: bedford)) }

        let(:permissions) { { sso: { info: { permissions: [{'organisation' => bedford_sso_id}]}} } }

        it "redirects to root path" do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(200)
        end
      end

      context 'when the escort and the user do not belong to the same establishment' do
        let(:bedford_sso_id) { 'bedford.prisons.noms.moj' }
        let(:brixton_sso_id) { 'brixton.prisons.noms.moj' }
        let(:bedford_nomis_id) { 'BDI' }
        let(:bedford) { create(:prison, name: 'HMP Bedford', sso_id: bedford_sso_id, nomis_id: bedford_nomis_id) }
        let(:escort) { create(:escort, :completed, move: create(:move, from_establishment: bedford)) }

        let(:permissions) { { sso: { info: { permissions: [{'organisation' => brixton_sso_id}]}} } }

        it "redirects to root path" do
          get "/escorts/#{escort.id}"
          expect(response).to have_http_status(302)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
