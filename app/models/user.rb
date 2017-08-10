class User < ApplicationRecord
  ADMIN_ORGANISATION = 'digital.noms.moj'.freeze

  serialize :permissions

  class << self
    def from_omniauth(auth)
      user = where(email: auth.info.email).first
      if user
        user.update_attributes(
          provider: auth.provider,
          uid: auth.uid,
          permissions: auth.info.permissions
        )
      else
        user = first_or_create_by_uid_and_provider(auth)
      end
      user
    end

    private

    def first_or_create_by_uid_and_provider(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
        u.provider = auth.provider
        u.uid = auth.uid
        u.email = auth.info.email
        u.first_name = auth.info.first_name
        u.last_name = auth.info.last_name
        u.permissions = auth.info.permissions
      end
    end
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def authorized_establishments
    permissions.each_with_object([]) do |permission, locations|
      location = Establishment.find_by(sso_id: permission['organisation'])
      locations << location if location
    end
  end

  def is_admin?
    permissions.any? { |permission| permission['organisation'] == ADMIN_ORGANISATION }
  end
end
