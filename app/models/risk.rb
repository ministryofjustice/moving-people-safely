class Risk < ApplicationRecord
  include Questionable

  act_as_assessment :risk

  STATES = {
    incomplete: 0,
    needs_review: 1,
    unconfirmed: 2,
    confirmed: 3
  }.freeze

  enum status: STATES

  belongs_to :escort
  belongs_to :reviewer, class_name: 'User'

  scope :not_confirmed, -> { where.not(status: :confirmed) }

  def confirm!(user:)
    update_attributes!(
      reviewer_id: user.id,
      reviewed_at: DateTime.now,
      status: :confirmed
    )
  end
end
