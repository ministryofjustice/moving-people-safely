require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  let(:escort) { FactoryGirl.create :escort }
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
          date_picker: date,
          commit: commit
        }
    end

    let(:search) { 'A1234AB' }
    let(:date) { '01/02/2003' }
    let(:commit) { 'Go' }

    context "with a valid date" do
      it "redirects to /" do
        expect(response).to redirect_to "/?search=#{search}"
      end

      it "leaves the user submitted value in the session" do
        expect(session[:date_in_view]).to eql date
      end
    end

    context "submit with 'today'" do
      let(:commit) { 'today' }

      it "sets todays date in the session" do
        expect(session[:date_in_view]).to eql Date.today.strftime('%d/%m/%Y')
      end
    end

    context "with a previously viewed date in the session" do
      describe ">" do
        it "increments the date in the session" do
          post "/date",
            params: {
              search: search,
              date_picker: date,
              commit: '>'
            }

            expect(session[:date_in_view]).to eql '02/02/2003'
        end
      end
    end
  end
end
