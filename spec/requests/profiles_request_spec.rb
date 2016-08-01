require 'rails_helper'

RSpec.describe 'Profiles Requests', type: :request do
  before { sign_in FactoryGirl.create(:user) }
  let(:detainee) { escort.detainee }

  describe "#show" do
    context "with a valid escort ID" do
      let(:escort) { FactoryGirl.create :escort }

      it "responds with 200" do
        get "/#{escort.id}/profile"
        expect(response.status).to eql 200
      end
    end

    context "with a previously issued PER" do
      let(:escort) { FactoryGirl.create :escort, :previously_issued }

      it "redirects to the home page if there's no referrer" do
        get "/#{escort.id}/profile"
        expect(response.status).to eql 302
        expect(response).to redirect_to '/'
      end
    end

    context "with an invalid escort ID" do
      it "throws a record not found exception" do
        expect { get "/xxx/profile" }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end
