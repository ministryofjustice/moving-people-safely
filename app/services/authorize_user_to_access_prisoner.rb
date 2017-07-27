class AuthorizeUserToAccessPrisoner
  ADMIN_ORGANISATION = 'digital.noms.moj'.freeze

  def self.call(user, prison_number)
    new(user, prison_number).call
  end

  def initialize(user, prison_number)
    @user = user
    @prison_number = prison_number
  end

  def call
    return true if user_is_admin?
    user_authorized_locations.include?(prisoner_location)
  end

  private

  attr_reader :user, :prison_number

  def prisoner_location
    response = Detainees::LocationFetcher.new(prison_number).call
    Establishment.find_by(nomis_id: response.to_h[:code])
  end

  def user_authorized_locations
    user.permissions.each_with_object([]) do |permission, locations|
      location = Establishment.find_by(sso_id: permission['organisation'])
      locations << location if location
    end
  end

  def user_is_admin?
    user.permissions.any? { |permission| permission['organisation'] == ADMIN_ORGANISATION }
  end
end
