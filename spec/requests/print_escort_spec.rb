require 'rails_helper'

RSpec.describe 'Escorts::PrintController', type: :request do
  let(:escort) { create(:escort, :completed) }

  describe "#show" do
    context 'when user is not authorized' do
      it 'redirects user to login page' do
        get "/escorts/#{escort.id}/print"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_session_path
      end
    end

    context 'when user is authorized' do
      before { sign_in(create(:user)) }

      context 'when the escort for the provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            get "/escorts/#{SecureRandom.uuid}/print"
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "with a printable PER" do
        let(:escort) { create(:escort, :completed) }

        it "marks the PER as issued if hasn't been issued already" do
          expect {
            get "/escorts/#{escort.id}/print"
          }.to change { escort.reload.issued? }.from(false).to(true)
        end

        it "creates an audit" do
          expect {
            get "/escorts/#{escort.id}/print"
          }.to change { escort.reload.audits.count }.from(0).to(1)
        end

        specify {
          get "/escorts/#{escort.id}/print"
          expect(response).to have_http_status(200)
        }

        context 'when PER has been issued already' do
          let(:escort) { create(:escort, :issued) }

          it "does not attempt to issue the PER again" do
            expect(EscortIssuer).not_to receive(:call).with(escort)
            expect {
              get "/escorts/#{escort.id}/print"
            }.not_to change { escort.reload.issued? }.from(true)
          end

          it "creates an audit" do
            expect {
              get "/escorts/#{escort.id}/print"
            }.to change { escort.reload.audits.count }.from(0).to(1)
          end

          specify {
            get "/escorts/#{escort.id}/print"
            expect(response).to have_http_status(200)
          }
        end
      end

      context "with an incomplete PER" do
        let(:escort) { create(:escort) }

        it "redirects back to the referring page" do
          get "/escorts/#{escort.id}/print", headers: { "HTTP_REFERER" => 'prev_page' }
          expect(response).to redirect_to 'prev_page'
        end
      end
    end
  end
end
