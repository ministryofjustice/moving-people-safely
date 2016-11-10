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

    context "with valid search params" do
      before { get '/?prison_number=A1234AB' }

      it "responds with a 200 code" do
        expect(response.status).to eql 200
      end
    end

    context "with invalid search params" do
      before { get '/?prison_number=FAIL' }

      it "responds with a 200 code" do
        expect(response.status).to eql 200
      end
    end
  end

  describe "#detainees" do
    before do
      post detainees_search_path, params: { 'prison_number' => 'XXX' }
    end

    it "redirects to /" do
      expect(response).to redirect_to "/?prison_number=XXX"
    end
  end

  describe "#moves" do
    let(:params) {
      {
        prison_number: prison_number,
        moves_due_on: date,
        commit: commit
      }
    }
    before do
      post moves_search_path, params: params
    end

    let(:prison_number) { 'A1234AB' }
    let(:date) { '01/02/2003' }
    let(:commit) { 'Go' }

    context "with a valid date" do
      it "redirects to /" do
        expect(response).to redirect_to root_path(prison_number: prison_number)
      end

      it "leaves the user submitted value in the session" do
        expect(session[:moves_due_on]).to eql date
      end
    end

    context "submit with 'today'" do
      let(:commit) { 'today' }

      it "sets todays date in the session" do
        expect(session[:moves_due_on]).to eql Date.today.strftime('%d/%m/%Y')
      end
    end

    context "with a previously viewed date in the session" do
      describe ">" do
        it "increments the date in the session" do
          post moves_search_path,
            params: {
              prison_number: prison_number,
              moves_due_on: date,
              commit: '>'
            }

            expect(session[:moves_due_on]).to eql '02/02/2003'
        end
      end
    end
  end
end
