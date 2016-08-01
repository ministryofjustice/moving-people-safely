class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy

  has_one :healthcare_workflow, -> { where type: "healthcare" }, class_name: 'Workflow'
  has_one :risk_workflow, -> { where type: "risk" }, class_name: 'Workflow'
  has_one :offences_workflow, -> { where type: "offences" }, class_name: 'Workflow'
  has_one :workflow, -> { where type: 'move' }, class_name: 'Workflow'

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

  scope :with_incomplete_risk, ->{ risk_workflow.not.completed }
  scope :with_incomplete_healthcare, -> { healthcare_workflow.not.complete }
  scope :with_incomplete_offences, ->{ offences_workflow.not.complete }

  def complete?
    risk_complete? &&
      healthcare_complete? &&
      offences_complete?
  end

  def risk_complete?
    risk_workflow.complete?
  end

  def healthcare_complete?
    healthcare_workflow.complete?
  end

  def offences_complete?
    offences_workflow.complete?
  end
end
