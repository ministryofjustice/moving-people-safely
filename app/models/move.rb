class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy
  has_one :move_workflow, foreign_key: :workflowable_id

  before_create :set_defaults

  scope :active, -> { joins(:move_workflow).merge(Workflow.not_issued) }

  delegate :status, :active?, :issued?, :issued!, to: :move_workflow

  def set_defaults
    move_workflow || build_move_workflow
  end
end
