require 'rails_helper'

RSpec.describe 'Profiles Requests', type: :request do
  before { sign_in FactoryGirl.create(:user) }
  let(:detainee) { FactoryGirl.create(:detainee, :with_active_move) }
  let(:move) { detainee.active_move }

  describe "#show" do
    context "with a valid escort ID" do
      it "responds with 200" do
        get "/detainees/#{detainee.id}/profile"
        expect(response.status).to eql 200
      end
    end

    context "with an invalid escort ID" do
      it "throws a record not found exception" do
        expect { get "/detainees/xxx/profile" }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end
