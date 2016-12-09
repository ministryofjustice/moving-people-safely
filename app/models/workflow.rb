class Workflow < ApplicationRecord
  belongs_to :move
  belongs_to :reviewer, class_name: 'User'

  WORKFLOW_STATES = {
    not_started: 0,
    incomplete: 1,
    needs_review: 2,
    unconfirmed: 3,
    confirmed: 4,
    issued: 5
  }.freeze

  enum status: WORKFLOW_STATES

  scope :not_confirmed, -> { where.not(status: :confirmed) }

  def self.sti_name
    name.demodulize.gsub('Workflow', '').downcase
  end

  def self.find_sti_class(type_name)
    type_name = "#{type_name.capitalize}Workflow"
    super
  end

  def confirm_with_user!(user:)
    update_attributes!(
      reviewer_id: user.id,
      reviewed_at: DateTime.now,
      status: :confirmed
    )
  end

  concerning :AppliesToMoveWorkflowOnly do
    included do
      scope :not_issued, -> { where.not(status: :issued) }

      def active?
        !issued?
      end
    end
  end
end
