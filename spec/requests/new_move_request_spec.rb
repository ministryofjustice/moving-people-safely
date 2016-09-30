require 'rails_helper'

RSpec.describe 'New Move requests', type: :request do
  before { sign_in FactoryGirl.create(:user) }

  describe "#copy" do
    before { get "/#{detainee.id}/move/new" }

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
        expect(response.status).to eql 200
      end
    end
  end

  describe "#create" do
    let(:detainee) { create(:detainee) }

    before { post "/#{detainee.id}/move", params: { move: move_attrs } }

    context "when the submitted move validates" do
      let(:move_attrs) { attributes_for(:move) }
      it "redirects to the new move's profile" do
        expect(response).to redirect_to profile_path(Move.last)
      end
    end

    context "when the submitted move fails to validate" do
      let(:move_attrs) { attributes_for(:move).replace(reason: 'no good reason') }

      it "redirects to the copy move path" do
        expect(response).to redirect_to "/#{detainee.id}/move/new"
      end
    end
  end
end
