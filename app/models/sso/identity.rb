# frozen_string_literal: true

module SSO
  class Identity
    class << self
      # This is what the auth_hash from Omniauth looks like:
      # {
      #   "provider"=>"mojsso",
      #   "uid"=>3,
      #   "info"=> {
      #     "first_name"=>nil,
      #     "last_name"=>nil,
      #     "email"=>"user@example.com",
      #     "permissions"=> [{"organisation"=>"digital.noms.moj", "roles"=>["court", "prison"]}],
      #     "links"=> {
      #       "profile"=>"http://localhost:5000/profile",
      #       "logout"=>"http://localhost:5000/users/sign_out"
      #     }
      #   },
      #   "credentials"=> {
      #     "token"=>"000-whatever-0000",
      #     "expires_at"=>1551356382,
      #     "expires"=>true
      #   },
      #   "extra"=> {
      #     "raw_info"=> {
      #       "id"=>3,
      #       "email"=>"user@example.com",
      #       "first_name"=>nil,
      #       "last_name"=>nil,
      #       "permissions"=> [{"organisation"=>"digital.noms.moj", "roles"=>["court", "prison"]}],
      #       "links"=> {
      #         "profile"=>"http://localhost:5000/profile",
      #         "logout"=>"http://localhost:5000/users/sign_out"
      #       }
      #     }
      #   }
      # }
      def from_omniauth(auth_hash)
        info = auth_hash.fetch('info')
        credentials = auth_hash.fetch('credentials')
        user = User.from_omniauth(auth_hash)
        options = extract_additional_info(info, credentials)
        new(user, options)
      rescue
        nil
      end

      def from_session(hash)
        user = User.find(hash.fetch('user_id'))
        options = {
          profile_url: hash.fetch('profile_url'),
          logout_url: hash.fetch('logout_url'),
          permissions: hash.fetch('permissions'),
          token_expires_at: hash.fetch('token_expires_at'),
          token_expires: hash.fetch('token_expires')
        }
        new(user, options)
      end

      private

      def extract_additional_info(info, credentials)
        links = info.fetch('links')

        {
          profile_url: links.fetch('profile'),
          logout_url: links.fetch('logout'),
          permissions: info.fetch('permissions'),
          token_expires_at: credentials.fetch('expires_at'),
          token_expires: credentials.fetch('expires')
        }
      end
    end

    attr_reader :user, :profile_url, :logout_url, :permissions,
      :token_expires_at, :token_expires

    def initialize(user, options)
      @user = user
      @profile_url = options.fetch(:profile_url)
      @logout_url = options.fetch(:logout_url)
      @permissions = options.fetch(:permissions)
      @token_expires_at = options.fetch(:token_expires_at)
      @token_expires = options.fetch(:token_expires)
    end

    def user_id
      user&.id
    end

    def to_h
      {
        'user_id' => user.id,
        'profile_url' => profile_url,
        'logout_url' => logout_url,
        'permissions' => permissions,
        'token_expires_at' => token_expires_at,
        'token_expires' => token_expires
      }
    end

    def live?
      return true unless token_expires

      Time.now.to_i < token_expires_at
    end
  end
end
