class AuthorizeUserToAccessPrisoner
  def self.call(user, prison_number)
    new(user, prison_number).call
  end

  def initialize(user, prison_number)
    @user = user
    @prison_number = prison_number
  end

  def call
    return true if user.admin?
    return true unless prisoner_location
    user.authorized_establishments.include?(prisoner_location)
  end

  private

  attr_reader :user, :prison_number

  def prisoner_location
    response = Detainees::LocationFetcher.new(prison_number).call
    Establishment.find_by(nomis_id: response.to_h[:code])
  end
end
