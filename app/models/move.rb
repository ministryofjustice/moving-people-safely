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

  INCOMPLETE_STATES = DocumentWorkflow::INCOMPLETE_STATES.map(&:to_s)

  scope :with_incomplete_risk, (lambda do
    joins(:risk).
    where('risks.workflow_status IN (?)', INCOMPLETE_STATES)
  end)

  scope :with_incomplete_healthcare, (lambda do
    joins(:healthcare).
    where('healthcare.workflow_status IN (?)', INCOMPLETE_STATES)
  end)

  scope :with_incomplete_offences, (lambda do
    joins(:offences).
    where('offences.workflow_status IN (?)', INCOMPLETE_STATES)
  end)

  def complete?
    risk_complete? &&
      healthcare_complete? &&
      offences_complete?
  end

  def risk_complete?
    test_completeness(risk)
  end

  def healthcare_complete?
    test_completeness(healthcare)
  end

  def offences_complete?
    test_completeness(offences)
  end

  private

  def test_completeness(model)
    DocumentWorkflow.new(model).is_confirmed?
  end
end
