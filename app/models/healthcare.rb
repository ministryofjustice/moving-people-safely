class Healthcare < ApplicationRecord
  include Questionable
  act_as_assessment :healthcare, complex_attributes: %i[medications]

  after_initialize :set_default_values

  def set_default_values
    unless read_attribute(:contact_number).present?
      write_attribute(:contact_number, default_contact_number)
    end
  end

  STATES = {
    incomplete: 0,
    needs_review: 1,
    unconfirmed: 2,
    confirmed: 3
  }.freeze

  enum status: STATES

  belongs_to :escort
  belongs_to :reviewer, class_name: 'User'

  scope :not_confirmed, -> { where.not(status: :confirmed) }

  delegate :current_establishment, to: :escort, allow_nil: true

  def confirm!(user:)
    update_attributes!(
      reviewer_id: user.id,
      reviewed_at: DateTime.now,
      status: :confirmed
    )
  end

  def default_contact_number
    current_establishment&.default_healthcare_contact_number
  end

  def reviewed?
    reviewer.present? && reviewed_at.present?
  end
end
