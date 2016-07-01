require 'rails_helper'

RSpec.describe OffensesController, type: :controller do
  let(:escort) { Escort.create }

  describe "#show" do
    before { process :show, method: :get, params: { escort_id: escort.id } }

    context "not logged in" do
      it "redirects to /sign_in" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    it "returns status 200" do
      expect(response.status).to_be :ok
    end

    context "form data in the flash" do
    end
  end
end