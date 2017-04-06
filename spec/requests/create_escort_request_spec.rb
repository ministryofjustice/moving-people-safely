require 'rails_helper'

RSpec.describe 'Create escort request', type: :request do
  let(:prison_number) { 'A1234AY' }

  before { sign_in create(:user) }

  context 'when there is no previous escort for given prison number' do
    it 'creates a brand new escort record and redirects to the new detainee form' do
      expect {
        post '/escorts', params: { escort: { prison_number: prison_number } }
      }.to change { Escort.where(prison_number: prison_number).count }.from(0).to(1)

      escort = Escort.where(prison_number: prison_number).first
      expect(escort.detainee).to be_nil
      expect(escort.move).to be_nil

      expect(response).to redirect_to(new_escort_detainee_path(escort, prison_number: prison_number))
    end
  end

  context 'when there is a previous escort for given prison number' do
    let(:detainee) { create(:detainee) }
    let(:move) { create(:move) }
    let!(:existent_escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

    it 'creates a new escort record with the data from the existent escort and redirects to the new move form' do
      expect {
        post '/escorts', params: { escort: { prison_number: prison_number } }
      }.to change { Escort.where(prison_number: prison_number).count }.from(1).to(2)

      escort = Escort.where(prison_number: prison_number).first
      expect(escort.detainee).to be_an_instance_of(Detainee)
      expect(escort.move).to be_an_instance_of(Move)

      expect(response).to redirect_to(edit_escort_move_path(escort))
    end
  end
end
