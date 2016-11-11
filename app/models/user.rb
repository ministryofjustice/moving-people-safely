class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
    :trackable, :validatable, :timeoutable,
    :omniauthable, omniauth_providers: [:mojsso]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
