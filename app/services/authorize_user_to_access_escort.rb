class AuthorizeUserToAccessEscort
  def self.call(user, escort)
    new(user, escort).call
  end

  def initialize(user, escort)
    @user = user
    @escort = escort
  end

  def call
    return true if user.is_admin?
    user.authorized_establishments.any? { |e| e.sso_id == escort.move&.from_establishment&.sso_id }
  end

  private

  attr_reader :user, :escort
end
