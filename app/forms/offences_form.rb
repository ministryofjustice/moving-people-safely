class OffencesForm < Forms::Base
  property :release_date, type: TextDate, validates: { presence: true }
  property :not_for_release, type: Axiom::Types::Boolean
  property :not_for_release_reason, type: String

  validate :validate_release_date

  def validate_release_date
    errors.add(:release_date) unless release_date.is_a? Date
  end
end