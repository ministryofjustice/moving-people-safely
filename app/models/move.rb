class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy

  has_one :detainee, through: :escort
  has_one :healthcare, through: :escort
  has_one :offences, through: :escort
  has_one :risk, through: :escort

  scope :for_date, (lambda do |search_date|
    where(date: search_date).
      order(created_at: :desc).
      eager_load(
        :detainee,
        :escort,
        :healthcare,
        :offences,
        :risk
      )
  end)

  INCOMPLETE_STATUSES = %w[not_started incomplete needs_review]

  scope :with_incomplete_risk, (lambda do
    joins(:risk).
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
    risk_complete? &&
      healthcare_complete? &&
      offences_complete?
  end

  def risk_complete?
    risk.complete?
  end

  def healthcare_complete?
    healthcare.complete?
  end

  def offences_complete?
    offences.complete?
  end
end
