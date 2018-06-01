class Healthcare < ApplicationRecord
  include Questionable
  include Reviewable

  SECTIONS = %w[physical mental transport needs dependencies allergies social contact].freeze
  MANDATORY_QUESTIONS = %w[physical_issues mental_illness personal_care allergies
                           dependencies has_medications mpv contact_number].freeze

  belongs_to :escort
  has_many :medications, dependent: :destroy

  delegate :editable?, to: :escort

  after_initialize :set_default_values

  def set_default_values
    return if read_attribute(:contact_number).present?
    return unless escort&.from_establishment
    write_attribute(:contact_number, escort.from_establishment.healthcare_contact_number)
  end

  def relevant_questions
    @relevant_questions ||= MANDATORY_QUESTIONS.select do |question|
      answer = public_send(question)
      answer == 'yes' || (answer.present? && answer != 'no')
    end
  end
end
