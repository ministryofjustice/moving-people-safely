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
        FactoryGirl.create(:user, email: 'bob@example.com')
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
        FactoryGirl.create(:user, uid: uid, provider: provider, first_name: 'Local First Name')
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
end
