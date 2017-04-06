require 'rails_helper'

RSpec.describe 'New Move requests', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }

  describe "#new" do
    context "when the user is not authorized" do
      it "user is redirected to the login page" do
        get "/escorts/#{escort.id}/move/new"
        expect(response).to redirect_to new_session_path
      end
    end

    context 'when the user is authorized' do
      before { sign_in create(:user) }

      context 'but the escort with provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            get "/escorts/#{SecureRandom.uuid}/move/new"
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'but the escort is no longer editable' do
        let(:move) { create(:move, :issued) }
        let(:escort) { create(:escort, detainee: detainee, move: move) }

        it 'redirects to the homepage displaying an appropriate error' do
          get "/escorts/#{escort.id}/move/new"
          expect(flash[:alert]).to eq('The PER can no longer be changed.')
          expect(response).to have_http_status(302)
        end
      end

      context "when the PER already has a move" do
        let(:move) { create(:move, :active) }
        let(:escort) { create(:escort, detainee: detainee, move: move) }

        it "redirects to the PER page" do
          get "/escorts/#{escort.id}/move/new"
          expect(response).to redirect_to escort_path(escort)
        end
      end

      it "the request is successful" do
        get "/escorts/#{escort.id}/move/new"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "#create" do
    let(:move_params) { { move: attributes_for(:move) } }

    context "when the user is not authorized" do
      it "user is redirected to the login page" do
        post "/escorts/#{escort.id}/move", params: move_params
        expect(response).to redirect_to new_session_path
      end
    end

    context 'when the user is authorized' do
      before { sign_in create(:user) }

      context 'but the escort with provided id does not exist' do
        it 'raises a record not found error' do
          expect {
            post "/escorts/#{SecureRandom.uuid}/move", params: move_params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'but the escort is no longer editable' do
        let(:move) { create(:move, :issued) }
        let(:escort) { create(:escort, detainee: detainee, move: move) }

        it 'redirects to the homepage displaying an appropriate error' do
          post "/escorts/#{escort.id}/move", params: move_params
          expect(flash[:alert]).to eq('The PER can no longer be changed.')
          expect(response).to have_http_status(302)
        end
      end

      context "when the PER already has a move" do
        let(:move) { create(:move, :active) }
        let(:escort) { create(:escort, detainee: detainee, move: move) }

        it "redirects to the PER page displaying the appropriate error" do
          expect {
            post "/escorts/#{escort.id}/move", params: move_params
          }.not_to change { escort.reload.move }.from(move)
          expect(flash[:alert]).to eq('Move details for the PER already exist.')
          expect(response).to redirect_to escort_path(escort)
        end
      end

      context "when the submitted move details are valid" do
        it "redirects successfully to the PER page" do
          expect {
            post "/escorts/#{escort.id}/move", params: move_params
          }.to change { escort.reload.move }.from(nil).to(an_instance_of(Move))
          expect(flash[:alert]).to be_nil
          expect(response).to redirect_to escort_path(escort)
        end
      end

      context "when the submitted move details are not valid" do
        let(:move_params) { { move: attributes_for(:move).except(:date) } }

        it "does not redirect to the detainee's profile" do
          expect {
            post "/escorts/#{escort.id}/move", params: move_params
          }.not_to change { escort.reload.move }.from(nil)
          expect(response).not_to redirect_to escort_path(escort)
        end
      end
    end
  end
end
