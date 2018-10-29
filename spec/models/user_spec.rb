require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    let(:provider) { 'mojsso' }
    let(:uid) { 4 }
    let(:hash) {
      {
       "provider"=> provider,
       "uid"=> uid,
       "info"=>
        {"first_name"=>"Bob",
         "last_name"=>"Barnes",
         "email"=>"bob@example.com",
         "permissions"=>[{"organisation"=>"digital.noms.moj", "roles"=>[]}],
         "links"=>{"profile"=>"http://localhost:5000/profile", "logout"=>"http://localhost:5000/users/sign_out"}},
       "credentials"=>{"token"=>"d6cbfee29b2131637e714ed96dfae1ea9aa31015b7bf41a4e1b0ba29c27d59fc", "expires_at"=>1481560460, "expires"=>true},
       "extra"=>
        {"raw_info"=>
          {"id"=>4,
           "email"=>"bob@example.com",
           "first_name"=>"Bob",
           "last_name"=>"Barnes",
           "permissions"=>[{"organisation"=>"digital.noms.moj", "roles"=>[]}],
           "links"=>{"profile"=>"http://localhost:5000/profile", "logout"=>"http://localhost:5000/users/sign_out"}}}
      }
    }
    let(:auth) { OmniAuth::AuthHash.new(hash) }

    context 'when the user with provided email already exists in the local database' do
      before do
        create(:user, email: 'bob@example.com')
      end

      it 'does not create a new user' do
        expect { described_class.from_omniauth(auth) }.not_to change { User.count }
      end

      it 'updates the uid and provider details for the existent user' do
        expect {
          described_class.from_omniauth(auth)
        }.to change {
          User.where(email: 'bob@example.com').last.attributes.slice('uid', 'provider')
        }.from({ 'uid' => nil, 'provider' => nil })
          .to({ 'uid' => '4', 'provider' => 'mojsso' })
      end
    end

    context 'when the user with provided uid and provider already exists in the local database' do
      before do
        create(:user, uid: uid, provider: provider, first_name: 'Local First Name')
      end

      it 'does not create a new user' do
        expect { described_class.from_omniauth(auth) }.not_to change { User.count }
      end

      it 'returns the existent user' do
        user = described_class.from_omniauth(auth)
        expect(user.uid.to_s).to eq(uid.to_s)
        expect(user.provider).to eq(provider)
        expect(user.first_name).to eq('Local First Name')
      end
    end

    it 'creates a new user with the data received' do
      expect { described_class.from_omniauth(auth) }.to change { User.count }.by(1)
      user = User.where(provider: provider, uid: uid).last
      expect(user.email).to eq('bob@example.com')
      expect(user.first_name).to eq('Bob')
      expect(user.last_name).to eq('Barnes')
    end

    it 'returns the existent user' do
      user = described_class.from_omniauth(auth)
      expect(user.uid.to_s).to eq(uid.to_s)
      expect(user.provider).to eq(provider)
      expect(user.email).to eq('bob@example.com')
      expect(user.first_name).to eq('Bob')
      expect(user.last_name).to eq('Barnes')
    end
  end

  describe '#full_name' do
    context 'when only the first name is present' do
      it 'return just the first name' do
        user = User.new(first_name: 'Bob')
        expect(user.full_name).to eq('Bob')
        user = User.new(first_name: 'Bob', last_name: '')
        expect(user.full_name).to eq('Bob')
      end
    end

    context 'when only the last name is present' do
      it 'return just the last name' do
        user = User.new(last_name: 'Barnes')
        expect(user.full_name).to eq('Barnes')
        user = User.new(first_name: '', last_name: 'Barnes')
        expect(user.full_name).to eq('Barnes')
      end
    end

    context 'when both first name and last name are present' do
      it 'return both first name and last name' do
        user = User.new(first_name: 'Bob', last_name: 'Barnes')
        expect(user.full_name).to eq('Bob Barnes')
      end
    end
  end

  describe '#admin?' do
    context 'when is admin' do
      subject { described_class.new(permissions: [{"organisation"=>User::ADMIN_ORGANISATION}])}

      it 'returns true' do
        expect(subject.admin?).to be_truthy
      end
    end

    context 'when is not admin' do
      subject { described_class.new(permissions: []) }

      it 'returns false' do
        expect(subject.admin?).to be_falsey
      end
    end
  end

  describe '#court?' do
    context 'when belongs to court staff' do
      subject { described_class.new(permissions: [{"organisation"=>User::COURT_ORGANISATION}])}

      it 'returns true' do
        expect(subject.court?).to be_truthy
      end
    end

    context 'when is not court staff' do
      subject { described_class.new(permissions: []) }

      it 'returns false' do
        expect(subject.court?).to be_falsey
      end
    end
  end

  describe '#police?' do
    context 'when belongs to police custody' do
      subject { described_class.new(permissions: [{"organisation"=>User::POLICE_ORGANISATION}])}

      it 'returns true' do
        expect(subject.police?).to be_truthy
      end
    end

    context 'when is not police custody' do
      subject { described_class.new(permissions: []) }

      it 'returns false' do
        expect(subject.police?).to be_falsey
      end
    end
  end

  describe '#sergeant?' do
    context 'when is sergeant' do
      subject { described_class.new(permissions: [{"organisation"=>User::POLICE_ORGANISATION}, {"roles"=>['sergeant']}])}

      it 'returns true' do
        expect(subject.sergeant?).to be_truthy
      end
    end

    context 'when is not sergeant' do
      subject { described_class.new(permissions: []) }

      it 'returns false' do
        expect(subject.sergeant?).to be_falsey
      end
    end
  end

  describe '#prison_officer?' do
    context 'when belongs to prison staff' do
      subject { described_class.new(permissions: [{"organisation"=>'bedford.prisons.noms.moj'}])}

      it 'returns true' do
        expect(subject.prison_officer?).to be_truthy
      end
    end

    context 'when is not prison officer' do
      subject { described_class.new(permissions: []) }

      it 'returns false' do
        expect(subject.prison_officer?).to be_falsey
      end
    end
  end

  describe '#healthcare?' do
    context 'when is healthcare' do
      subject { described_class.new(permissions: [{"organisation"=>'bedford.prisons.noms.moj'}, {"roles"=>['healthcare']}])}

      it 'returns true' do
        expect(subject.healthcare?).to be_truthy
      end
    end

    context 'when is not healthcare' do
      subject { described_class.new(permissions: []) }

      it 'returns fals' do
        expect(subject.healthcare?).to be_falsey
      end
    end
  end

  describe '#authorized_establishments' do
    let!(:bedford) { create(:establishment, sso_id: 'bedford.prisons.noms.moj')}
    let!(:pentonville) { create(:establishment, sso_id: 'pentonville.prisons.noms.moj')}
    let(:permissions) {
      [
        { 'organisation' => 'bedford.prisons.noms.moj' },
        { 'organisation' => 'pentonville.prisons.noms.moj' }
      ]
    }
    subject { described_class.new(permissions: permissions)}

    it 'returns the establishments' do
      expect(subject.authorized_establishments).to eq [bedford, pentonville]
    end
  end

  describe '#establishment' do
    let!(:bedford) { create(:establishment, sso_id: 'bedford.prisons.noms.moj')}
    let!(:pentonville) { create(:establishment, sso_id: 'pentonville.prisons.noms.moj')}
    let!(:thorpe) { create(:police_custody, name: 'Thorpe Police Station')}

    context 'when is prison_officer' do
      let(:permissions) {
        [
          { 'organisation' => 'bedford.prisons.noms.moj' },
          { 'organisation' => 'pentonville.prisons.noms.moj' }
        ]
      }

      subject { described_class.new(permissions: permissions)}

      it 'returns the first establishment' do
        expect(subject.establishment({})).to eq bedford
      end
    end

    context 'when is police' do
      let(:permissions) {
        [
          { 'organisation' => 'police.noms.moj' }
        ]
      }

      subject { described_class.new(permissions: permissions)}

      it 'returns the police custody station' do
        expect(subject.establishment(police_station_id: thorpe.id)).to eq PoliceCustody.find(thorpe.id)
      end
    end
  end


  describe '#can_access_escort?' do
    let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }
    let(:prison) { create(:prison, sso_id: establishment_sso_id) }
    let(:move) { create(:move, from_establishment: prison) }
    let(:escort) { create(:escort, move: move)}
    let(:user) { described_class.new(permissions: []) }

    subject { user.can_access_escort?(escort)  }

    context 'when the user is an admin' do
      let(:permissions) {
        [
          { 'organisation' => User::ADMIN_ORGANISATION }
        ]
      }
      let(:user) { described_class.new(permissions: permissions) }

      specify { is_expected.to be_truthy }
    end

    context 'when the move has not an establishment set' do
      let(:move) { nil }

      specify { is_expected.to be_truthy }
    end

    context 'when the user tries to access an escort of the same prison' do
      let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }
      let(:permissions) {
        [
          { 'organisation' => 'bedford.prisons.noms.moj' }
        ]
      }
      let(:user) { described_class.new(permissions: permissions) }

      specify { is_expected.to be_truthy }
    end

    context 'when the user tries to access an escort of another prison' do
      let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }

      let(:permissions) {
        [
          { 'organisation' => 'pentonville.prisons.noms.moj' }
        ]
      }
      let(:user) { described_class.new(permissions: permissions) }

      specify { is_expected.to be_falsey }
    end
  end
end
