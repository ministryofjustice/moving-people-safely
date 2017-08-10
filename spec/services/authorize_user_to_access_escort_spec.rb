require 'rails_helper'

RSpec.describe AuthorizeUserToAccessEscort do
  let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }
  let(:prison) { create(:prison, sso_id: establishment_sso_id) }
  let(:move) { create(:move, from_establishment: prison) }
  let(:escort) { create(:escort, move: move)}

  subject(:service) { described_class.call(user, escort) }

  context 'when the user is an admin' do
    let(:user) { create(:user, :admin) }

    specify { is_expected.to be_truthy }
  end

  context 'when the user is not an admin' do
    context 'when the user tries to access an escort of the same prison' do
      let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }
      let(:permissions) {
        [
          { 'organisation' => 'bedford.prisons.noms.moj' }
        ]
      }
      let(:user) { create(:user, permissions: permissions) }

      specify { is_expected.to be_truthy }
    end

    context 'when the user tries to access an escort of another prison' do
      let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }

      let(:permissions) {
        [
          { 'organisation' => 'pentonville.prisons.noms.moj' }
        ]
      }
      let(:user) { create(:user, permissions: permissions) }

      specify { is_expected.to be_falsey }
    end
  end
end
