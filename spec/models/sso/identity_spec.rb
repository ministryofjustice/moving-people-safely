require 'rails_helper'

RSpec.describe SSO::Identity, type: :model do

  describe '.from_omniauth' do
    let(:provider) { 'mojsso' }
    let(:uid) { 4 }
    let(:permissions) { [{"organisation"=>"digital.noms.moj", "roles"=>[]}] }
    let(:links) {
      {
        "profile" => "http://localhost:5000/profile",
        "logout" => "http://localhost:5000/users/sign_out"
      }
    }
    let(:info) {
      {
        "first_name" => "Bob",
        "last_name" => "Barnes",
        "email" => "bob@example.com",
        "permissions" => permissions,
        "links" => links
      }
    }
    let(:hash) {
      {
        "provider" => provider,
        "uid" => uid,
        "info" => info,
        "credentials" => {
          "token" => "d6cbfee29b2131637e714ed96dfae1ea9aa31015b7bf41a4e1b0ba29c27d59fc",
          "expires_at" => 1481560460,
          "expires" => true
        },
        "extra" =>
        { "raw_info" => { "id" => 4 }.merge(info) }
      }
    }
    let(:auth) { OmniAuth::AuthHash.new(hash) }

    context 'when oauth info is missing' do
      let(:auth) { OmniAuth::AuthHash.new(hash.except('info')) }

      it 'returns nil' do
        expect(described_class.from_omniauth(auth)).to be_nil
      end
    end

    context 'when oauth links are missing' do
      let(:info) { super().except('links') }

      it 'returns nil' do
        expect(described_class.from_omniauth(auth)).to be_nil
      end
    end

    context 'when oauth profile link is missing' do
      let(:links) { { "logout" => "http://localhost:5000/users/sign_out" } }

      it 'returns nil' do
        expect(described_class.from_omniauth(auth)).to be_nil
      end
    end

    context 'when oauth logout link is missing' do
      let(:links) { { "profile" => "http://localhost:5000/profile" } }

      it 'returns nil' do
        expect(described_class.from_omniauth(auth)).to be_nil
      end
    end

    context 'when oauth permissions are missing' do
      let(:info) { super().except('permissions') }

      it 'returns nil' do
        expect(described_class.from_omniauth(auth)).to be_nil
      end
    end

    context 'when all the mandatory oauth info is provided' do
      it 'returns an instance of the SSO identity' do
        identity = described_class.from_omniauth(auth)
        expect(identity).to be_instance_of(described_class)
        expected_hash = {
          'profile_url' => 'http://localhost:5000/profile',
          'logout_url' => 'http://localhost:5000/users/sign_out',
          'permissions' => permissions
        }
        expect(identity.to_h).to include(expected_hash)
      end
    end
  end

  describe '.from_session' do
    let(:user) { create(:user) }
    let(:session_hash) {
      {
        'user_id' => user.id,
        'profile_url' => 'http://localhost:5000/profile',
        'logout_url' => 'http://localhost:5000/users/sign_out',
        'permissions' => [{"organisation"=>"digital.noms.moj", "roles"=>[]}],
        'token_expires' => true,
        'token_expires_at' => 123
      }
    }

    context 'when user_id is missing from session data' do
      let(:session_hash) { super().except('user_id') }

      specify {
        expect {
          described_class.from_session(session_hash)
        }.to raise_error(KeyError, /key not found: "user_id"/)
      }
    end

    context 'when there is no user for session user id' do
      let(:session_hash) { super().merge('user_id' => 99999) }

      specify {
        expect {
          described_class.from_session(session_hash)
        }.to raise_error(ActiveRecord::RecordNotFound, /Couldn't find User with 'id'=99999/)
      }
    end

    context 'when profile_url is missing from session data' do
      let(:session_hash) { super().except('profile_url') }

      specify {
        expect {
          described_class.from_session(session_hash)
        }.to raise_error(KeyError, /key not found: "profile_url"/)
      }
    end

    context 'when logout_url is missing from session data' do
      let(:session_hash) { super().except('logout_url') }

      specify {
        expect {
          described_class.from_session(session_hash)
        }.to raise_error(KeyError, /key not found: "logout_url"/)
      }
    end

    context 'when permissions is missing from session data' do
      let(:session_hash) { super().except('permissions') }

      specify {
        expect {
          described_class.from_session(session_hash)
        }.to raise_error(KeyError, /key not found: "permissions"/)
      }
    end

    it 'returns the correct SSO identity for the provided session data' do
      identity = described_class.from_session(session_hash)
      expect(identity).to be_instance_of(described_class)
      expect(identity.to_h).to eq(session_hash)
    end
  end

  describe 'identity instance' do
    let(:user) { instance_double(User, id: 4) }
    let(:options) {
      {
        profile_url: 'http://localhost:5000/profile',
        logout_url: 'http://localhost:5000/users/sign_out',
        permissions: [{"organisation"=>"digital.noms.moj", "roles"=>[]}],
        token_expires_at: 345,
        token_expires: true
      }
    }

    subject { described_class.new(user, options) }

    describe '#user_id' do
      context 'when user is not present' do
        let(:user) { nil }
        specify { expect(subject.user_id).to be_nil }
      end

      context 'when user is present' do
        it 'returns the user identifier' do
          expect(subject.user_id).to eq(4)
        end
      end
    end

    describe '#to_h' do
      it 'returns a hash representation of the SSO identity' do
        expected_hash = {
          'user_id' => 4,
          'profile_url' => 'http://localhost:5000/profile',
          'logout_url' => 'http://localhost:5000/users/sign_out',
          'permissions' => [{"organisation"=>"digital.noms.moj", "roles"=>[]}],
          'token_expires_at' => 345,
          'token_expires' => true
        }
        expect(subject.to_h).to eq(expected_hash)
      end
    end
  end
end
