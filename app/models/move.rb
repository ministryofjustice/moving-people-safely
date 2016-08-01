class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy

  has_one :healthcare_workflow, -> { Workflow.healthcare }, class_name: 'Workflow'
  has_one :risk_workflow, -> { Workflow.risk }, class_name: 'Workflow'
  has_one :offences_workflow, -> { Workflow.offences }, class_name: 'Workflow'
  has_one :workflow, -> { Workflow.move }, class_name: 'Workflow'

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

  scope :active, -> { joins(:workflow).merge(Workflow.not_issued) }

  scope :with_incomplete_risk, -> { joins(:risk_workflow).merge(Workflow.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(:healthcare_workflow).merge(Workflow.not_confirmed) }
  scope :with_incomplete_offences, -> { joins(:offences_workflow).merge(Workflow.not_confirmed) }

  def initialize(*)
    super
    build_workflow
    build_risk_workflow
    build_healthcare_workflow
    build_offences_workflow
  end

  def complete?
    risk_complete? &&
      healthcare_complete? &&
      offences_complete?
  end

  def risk_complete?
    risk_workflow.confirmed?
  end

  def healthcare_complete?
    healthcare_workflow.confirmed?
  end

  def offences_complete?
    offences_workflow.confirmed?
  end
end
