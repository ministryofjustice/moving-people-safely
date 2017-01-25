require 'rails_helper'

RSpec.describe 'Copy Move requests', type: :request do
  before { sign_in FactoryGirl.create(:user) }

  describe "#copy" do
    before { get "/#{detainee.id}/move/copy" }

    context "when the detainee has a previously issued move" do
      let(:detainee) { create(:detainee, :with_completed_move) }

      it "responds with 200 OK" do
        expect(response.status).to eql 200
      end
    end

    context "when the detainee has an active move" do
      let(:detainee) { create(:detainee, :with_active_move) }

      it "redirects to the dashboard" do
        expect(response).to redirect_to root_path
      end
    end

    context "when the detainee has no previous moves" do
      let(:detainee) { create(:detainee) }

      it "redirects to the dashboard" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    let(:detainee) { create(:detainee) }

    before { post "/#{detainee.id}/move/copy", params: { move: move_attrs } }

    context "when the submitted move validates" do
      let(:move_attrs) { attributes_for(:move) }
      it "redirects to the new move's profile" do
        expect(response).to redirect_to detainee_path(detainee)
      end
    end

    context "when the submitted move fails to validate" do
      let(:move_attrs) { FactoryGirl.attributes_for(:move).except(:date) }

      it "does not redirect to the new move's profile" do
        expect(response).not_to redirect_to detainee_path(detainee)
      end
    end
  end
end
