require 'rails_helper'

RSpec.describe 'Moves::PrintController', type: :request do
  before do
    sign_in create(:user)
    detainee.moves << move
  end
  let(:detainee) { create(:detainee) }

  describe "#show" do
    context "with a printable PER" do
      let(:move) { create(:move, :confirmed) }

      it "marks the PER as issued if hasn't been issued already" do
        expect {
          get move_print_path(move)
        }.to change { move.reload.move_workflow.issued? }.from(false).to(true)
      end

      specify {
        get move_print_path(move)
        expect(response.status).to eq(200)
      }

      context 'when PER has been issued already' do
        let(:move) { create(:move, :issued) }

        it "does not attempt to issue the PER again" do
          expect {
            get move_print_path(move)
          }.not_to change { move.reload.move_workflow.issued? }.from(true)
        end

        specify {
          get move_print_path(move)
          expect(response.status).to eq(200)
        }
      end
    end

    context "with an incomplete PER" do
      before do
        get move_print_path(move), headers: { "HTTP_REFERER" => 'prev_page' }
      end
      let(:move) { create :move }

      it "redirects back to the referring page" do
        expect(response).to redirect_to 'prev_page'
      end
    end
  end
end
