class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy

  has_one :detainee, through: :escort
  has_one :healthcare, through: :escort
  has_one :offences, through: :escort
  has_one :risks, through: :escort

  scope :for_date, (lambda do |search_date|
    where(date: search_date).
      order(created_at: :desc).
      eager_load(
        :detainee,
        :escort,
        :healthcare,
        :offences,
        :risks
      )
  end)

  def risks_complete?
    risks.present? && risks.all_questions_answered?
  end

  def healthcare_complete?
    healthcare.present? && healthcare.all_questions_answered?
  end

  def offences_complete?
    offences.present? && offences.all_questions_answered?
  end
end
