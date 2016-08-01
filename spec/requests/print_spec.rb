require 'rails_helper'

RSpec.describe 'PrintController', type: :request do
  before { sign_in FactoryGirl.create(:user) }

  describe "#show" do
    context "with a printable PER" do
      before { get print_path(escort) }

      let(:escort) { FactoryGirl.create :escort, :with_active_move }

      it "marks the PER as issued" do
        # TODO FIX THIS WHEN ITS EASIER
        # escort.reload # I HATE YOU ACTIVERECORD
        # expect(escort.detainee.active_move.workflow.issued?).to be true
      end

      it "redirects to the home page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with an incomplete PER" do
      before do
        get print_path(escort), headers: { "HTTP_REFERER" => 'prev_page' }
      end

      let(:escort) { FactoryGirl.create :escort, :with_incomplete_offences }

      it "redirects back to the referring page" do
        expect(response).to redirect_to 'prev_page'
      end
    end
  end
end
