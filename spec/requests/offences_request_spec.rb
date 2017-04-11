require 'rails_helper'

RSpec.describe 'Offences', type: :request do
  let(:detainee) { create(:detainee) }
  let(:form_data) { 
    { 
      offences: {
        offences_attributes: {
          "0" => { 
            id: "some-uuid",
            offence: "some offence",
            case_reference: "1234LOL",
            _delete: "0"
          }
        }
      }
    }
  }

  describe "when not logged in" do
    it "get #show redirects to /sign_in" do
      get "/#{detainee.id}/offences"
      expect(response).to redirect_to new_session_path
    end

    it "patch #update redirects to /sign_in" do
      patch "/#{detainee.id}/offences", params: form_data
      expect(response).to redirect_to new_session_path
    end

    it "put #update redirects to /sign_in" do
      put "/#{detainee.id}/offences", params: form_data
      expect(response).to redirect_to new_session_path
    end
  end

  context "while logged in" do
    before { sign_in FactoryGirl.create(:user) }

    context "when offences don't exist" do
      let(:detainee) { create(:detainee, :with_active_move, :with_no_offences) }

      describe "#show" do
        it "calls the NOMIS API" do
          expect(Nomis::Api.instance).
            to receive(:get).with("/offenders/#{detainee.prison_number}/charges")

          get "/#{detainee.id}/offences"
        end

        context "when the NOMIS API is unavailable" do
          before do
            stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", status: 500)
          end

          it 'sets a flash error message indicating the image could not be prefetched' do
            get "/#{detainee.id}/offences"

            expect(flash[:warning]).
              to include("Offences aren't available right now, please try again or fill in the offences below")
          end
        end
      end
    end

    context "when offences already exist" do
      let(:detainee) { create(:detainee, :with_active_move) }

      describe "#show" do
        it "returns a 200 code" do
          get "/#{detainee.id}/offences"
          expect(response.status).to eql 200
        end

        it "does not call the NOMIS API" do
          expect(Nomis::Api.instance).not_to receive(:get)
          get "/#{detainee.id}/offences"
        end
      end

      describe "#update" do
        before { put "/#{detainee.id}/offences", params: form_data }

        context "with valid data" do
          it "redirects to the detainee's profile" do
            expect(response.status).to eql 302
            expect(response).to redirect_to "/detainees/#{detainee.id}"
          end
        end

        context "posted data fails validation" do
          let(:invalid_offence) { { "id"=>"", "offence"=>"" } }
          let(:form_data) { { offences: { offences_attributes: { '0' => invalid_offence } } } }

          it "redirects to #show" do
            expect(response).to redirect_to "/#{detainee.id}/offences"
          end
        end
      end
    end
  end
end
