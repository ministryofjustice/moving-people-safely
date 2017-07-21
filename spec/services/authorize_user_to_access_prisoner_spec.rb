require 'rails_helper'

RSpec.describe AuthorizeUserToAccessPrisoner do
  let(:prison_number) { 'A1234AB' }

  subject(:service) { described_class.call(user, prison_number) }

  context 'when the user is an admin' do
    let(:user) { create(:user, :admin) }

    specify { is_expected.to be_truthy }
  end

  context 'when the user is not an admin' do
    let(:permissions) {
      [
        { 'organisation' => 'bedford.prisons.noms.moj' },
        { 'organisation' => 'pentonville.prisons.noms.moj' }
      ]
    }
    let(:user) { create(:user, permissions: permissions) }
    let(:prison_code) { 'BDI' }
    let(:sso_prison_id) { 'bedford.prisons.noms.moj' }
    let!(:prison) { create(:prison, nomis_id: prison_code, sso_id: sso_prison_id) }
    let(:location_service) { double(Detainees::LocationFetcher) }
    let(:location_response) { { code: prison_code } }

    before do
      allow(Detainees::LocationFetcher).to receive(:new).with(prison_number).and_return(location_service)
      allow(location_service).to receive(:call).and_return(location_response)
    end


    context 'and the user location does not allow him/her to initiate a PER for the given prison number' do
      let(:permissions) {
        [
          { 'organisation' => 'some_other_prison.prisons.noms.moj' },
          { 'organisation' => 'pentonville.prisons.noms.moj' }
        ]
      }
      let(:some_other_prison_code) { 'SOI' }
      let(:some_other_sso_prison_id) { 'some_other_prison.prisons.noms.moj' }
      let!(:other_prison) { create(:prison, nomis_id: some_other_prison_code, sso_id: some_other_sso_prison_id) }

      specify { is_expected.to be_falsey }
    end

    context 'and the user location allows him/her to initiate a PER for the given prison number' do
      let(:permissions) {
        [
          { 'organisation' => 'bedford.prisons.noms.moj' },
          { 'organisation' => 'pentonville.prisons.noms.moj' }
        ]
      }
      specify { is_expected.to be_truthy }
    end
  end
end
