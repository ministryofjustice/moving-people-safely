module SSO
  class Identity
    class << self
      def from_omniauth(auth_hash)
        info = auth_hash.fetch('info')
        user = User.from_omniauth(auth_hash)
        options = extract_additional_info(info)
        new(user, options)
      rescue
        nil
      end

      def from_session(hash)
        user = User.find(hash.fetch('user_id'))
        options = {
          profile_url: hash.fetch('profile_url'),
          logout_url: hash.fetch('logout_url'),
          permissions: hash.fetch('permissions')
        }
        new(user, options)
      end

      private

      def extract_additional_info(hash)
        links = hash.fetch('links')

        {
          profile_url: links.fetch('profile'),
          logout_url: links.fetch('logout'),
          permissions: hash.fetch('permissions')
        }
      end
    end

    attr_reader :user, :profile_url, :logout_url, :permissions

    def initialize(user, options)
      @user = user
      @profile_url = options.fetch(:profile_url)
      @logout_url = options.fetch(:logout_url)
      @permissions = options.fetch(:permissions)
    end

    def user_id
      user && user.id
    end

    def to_h
      {
        'user_id' => user.id,
        'profile_url' => profile_url,
        'logout_url' => logout_url,
        'permissions' => permissions
      }
    end
  end
end
