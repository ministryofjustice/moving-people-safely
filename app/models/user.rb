class User < ApplicationRecord
  ADMIN_ORGANISATION = 'digital.noms.moj'.freeze
  COURT_ORGANISATION = 'courts.noms.moj'.freeze
  POLICE_ORGANISATION = 'police.noms.moj'.freeze
  PRISON_ORGANISATION = 'prisons.noms.moj'.freeze
  HEALTHCARE_ROLE = 'healthcare'.freeze
  SERGEANT_ROLE = 'sergeant'.freeze

  has_many :audits

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
    @authorized_establishments ||= permissions.each_with_object([]) do |permission, locations|
      location = Establishment.find_by(sso_id: permission['organisation'])
      locations << location if location
    end
  end

  def establishment(session)
    return authorized_establishments.first if prison_officer?
    PoliceCustody.find(session[:police_station_id]) if police? && session[:police_station_id]
  end

  def can_access_escort?(escort)
    return true if admin? || court? || police?
    escort_establishment_sso_id = escort.move&.from_establishment&.sso_id
    return true unless escort_establishment_sso_id
    authorized_establishments.any? { |establishment| establishment.sso_id == escort_establishment_sso_id }
  end

  def admin?
    permissions.any? { |permission| permission['organisation'] == ADMIN_ORGANISATION }
  end

  def court?
    permissions.any? { |permission| permission['organisation'] == COURT_ORGANISATION }
  end

  def police?
    permissions.any? { |permission| permission['organisation'] =~ /#{POLICE_ORGANISATION}/ }
  end

  def sergeant?
    police? && permissions.any? { |permission| permission['roles']&.include? SERGEANT_ROLE }
  end

  def prison_officer?
    permissions.any? { |permission| permission['organisation'] =~ /#{PRISON_ORGANISATION}/ }
  end

  def healthcare?
    prison_officer? && permissions.any? { |permission| permission['roles']&.include? HEALTHCARE_ROLE }
  end
end
