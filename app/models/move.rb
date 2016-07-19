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

  INCOMPLETE_STATUSES = %w[not_started incomplete needs_review]

  scope :with_incomplete_risks, (lambda do
    joins(:risks).
    where('risks.workflow_status IN (?)', INCOMPLETE_STATUSES)
  end)

  scope :with_incomplete_healthcare, (lambda do
    joins(:healthcare).
    where('healthcare.workflow_status IN (?)', INCOMPLETE_STATUSES)
  end)

  scope :with_incomplete_offences, (lambda do
    joins(:offences).
    where('offences.workflow_status IN (?)', INCOMPLETE_STATUSES)
  end)

  def complete?
    risks_complete? &&
      healthcare_complete? &&
      offences_complete?
  end

  def risks_complete?
    risks.complete?
  end

  def healthcare_complete?
    healthcare.complete?
  end

  def offences_complete?
    offences.complete?
  end
end
