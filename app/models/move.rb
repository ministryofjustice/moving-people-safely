class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy
  has_one :healthcare_workflow
  has_one :risk_workflow
  has_one :offences_workflow
  has_one :move_workflow

  scope :active, -> { joins(:move_workflow).merge(Workflow.not_issued) }

  delegate :status, :active?, :issued?, :issued!, to: :move_workflow

  def initialize(*)
    super
    build_move_workflow
    build_risk_workflow
    build_healthcare_workflow
    build_offences_workflow
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
