require 'rails_helper'

RSpec.describe OffensesController, type: :controller do
  let(:escort) { Escort.create }
  let(:user) { User.build }

  describe "#show" do

    context "not logged in" do
      it "redirects to /sign_in" do
        process :show, method: :get, params: { escort_id: escort.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    it "returns status 200" do
      process :show, method: :get, params: { escort_id: escort.id }
      expect(response.status).to_be :ok
    end

    context "form data in the flash" do
    end
  end
end