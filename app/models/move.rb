class Move < ApplicationRecord
  belongs_to :detainee
  has_many :destinations, dependent: :destroy

  has_one :healthcare_workflow
  has_one :risk_workflow
  has_one :offences_workflow
  has_one :move_workflow

  scope :for_date, (lambda do |search_date|
    where(date: search_date).
      order(created_at: :desc).
      eager_load(
        :detainee,
        :move_workflow
      )
  end)

  scope :active, -> { joins(:move_workflow).merge(Workflow.not_issued) }

  scope :with_incomplete_risk, -> { joins(:risk_workflow).merge(Workflow.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(:healthcare_workflow).merge(Workflow.not_confirmed) }
  scope :with_incomplete_offences, -> { joins(:offences_workflow).merge(Workflow.not_confirmed) }

  scope :order_by_recentness, -> { order(created_at: :desc) }

  delegate :active?, :issued?, to: :move_workflow

  def initialize(*)
    super
    build_move_workflow
    build_risk_workflow
    build_healthcare_workflow
    build_offences_workflow
  end

  def copy_without_saving
    dup.tap do |move|
      move.date = nil
    end
  end

  def save_copy
    transaction do
      create_move_workflow
      create_risk_workflow.needs_review!
      create_healthcare_workflow.needs_review!
      create_offences_workflow.needs_review!
    end
    save
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
