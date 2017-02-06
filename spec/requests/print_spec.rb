require 'rails_helper'

RSpec.describe 'PrintController', type: :request do
  before do
    sign_in FactoryGirl.create(:user)
    detainee.moves << move
  end
  let(:detainee) { create(:detainee) }

  describe "#show" do
    context "with a printable PER" do
      before { get print_path(move) }
      let(:move) { FactoryGirl.create(:move, :confirmed) }

      it "marks the PER as issued" do
        move.reload
        expect(move.move_workflow.issued?).to be_truthy
      end
    end

    context "with an incomplete PER" do
      before do
        get print_path(move), headers: { "HTTP_REFERER" => 'prev_page' }
      end
      let(:move) { FactoryGirl.create :move }

      it "redirects back to the referring page" do
        expect(response).to redirect_to 'prev_page'
      end
    end
  end
end
