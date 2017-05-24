class Workflow < ApplicationRecord
  belongs_to :detainee, foreign_key: :workflowable_id
  belongs_to :reviewer, class_name: 'User'

  WORKFLOW_STATES = {
    incomplete: 0,
    needs_review: 1,
    unconfirmed: 2,
    confirmed: 3,
    issued: 4
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
