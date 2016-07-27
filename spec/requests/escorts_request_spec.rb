require 'rails_helper'

RSpec.describe "Escorts request", type: :request do
  let(:escort) { FactoryGirl.create :escort }
  before { sign_in FactoryGirl.create(:user) }

  describe "POST /:escort_id/duplicate" do
    before { post "/#{escort.id}/duplicate" }
    let(:new_escort) { Escort.where(workflow_status: 'needs_review').last }

    it "redirects to /:new_escort_id/move-info" do
      expect(response).to redirect_to move_information_path(new_escort)
    end

    it "clones the escort" do
      expect(new_escort.id).not_to eql escort.id
      expect(new_escort.detainee.prison_number).to eql escort.detainee.prison_number
    end
  end
end
