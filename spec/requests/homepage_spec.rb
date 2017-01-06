require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  before { sign_in FactoryGirl.create(:user) }

  describe "#show" do
    context "with no search params" do
      before { get '/' }

      it "responds with a 200 code" do
        expect(response.status).to eql 200
      end
    end

    context "with validating search params" do
      before { get '/?search=A1234AB' }

      it "responds with a 200 code" do
        expect(response.status).to eql 200
      end
    end

    context "with invalid search params" do
      before { get '/?search=FAIL' }

      it "responds with a 200 code" do
        expect(response.status).to eql 200
      end
    end
  end

  describe "#search" do
    before do
      post "/search",
        params: {
          search: {
            'prison_number' => 'XXX'
          }
        }
    end

    it "redirects to /" do
      expect(response).to redirect_to "/?search=XXX"
    end
  end

  describe "#date_picker" do
    before do
      post "/date",
        params: {
          search: search,
          date_picker: date
        }
    end

    let(:search) { 'A1234AB' }
    let(:date) { '01/02/2003' }

    context "with a valid date" do
      it "redirects to /" do
        expect(response).to redirect_to "/?search=#{search}"
      end

      it "leaves the user submitted value in the session" do
        expect(session[:date_in_view]).to eql date
      end
    end
  end
end
