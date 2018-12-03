# frozen_string_literal: true

class Healthcare < ApplicationRecord
  include Questionable
  include Reviewable

  belongs_to :escort
  has_many :medications, dependent: :destroy

  delegate :editable?, :location, to: :escort

  after_initialize :set_default_values

  def set_default_values
    return if read_attribute(:contact_number).present?
    return unless escort&.move_from_establishment

    write_attribute(:contact_number, escort.move_from_establishment.healthcare_contact_number)
  end

  def alerts
    {
      pregnant: (pregnant == 'yes'),
      alcohol_withdrawal: (alcohol_withdrawal == 'yes')
    }
  end

  def relevant_questions
    mandatory_questions_for_gender.select do |question|
      answer = public_send(question)
      answer == 'yes' || (answer.present? && answer != 'no')
    end
  end

  def all_questions_answered?
    mandatory_questions_for_gender.all? do |question|
      public_send(question).present?
    end
  end

  def mandatory_questions_for_gender
    original = Healthcare.mandatory_questions(location)
    return original if escort&.detainee&.female?

    original - %w[pregnant female_hygiene_kit]
  end
end
