require 'rails_helper'

RSpec.describe 'PrintController', type: :request do
  before { sign_in FactoryGirl.create(:user) }

  describe "#show" do
    context "with a printable PER" do
      before { get print_path(escort) }

      let(:escort) { FactoryGirl.create :escort }

      it "marks the PER as issued" do
        expect(escort.workflow_status == 'issued')
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
