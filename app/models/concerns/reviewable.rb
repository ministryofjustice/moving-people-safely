# frozen_string_literal: true

require 'active_support/concern'

module Reviewable
  extend ActiveSupport::Concern

  STATES = {
    incomplete: 0,
    needs_review: 1,
    unconfirmed: 2,
    confirmed: 3
  }.freeze

  included do
    enum status: STATES

    belongs_to :reviewer, class_name: 'User'

    scope :not_confirmed, -> { where.not(status: :confirmed) }
  end

  def confirm!(user:)
    update_attributes!(
      reviewer_id: user.id,
      reviewed_at: Time.now,
      status: :confirmed
    )
  end

  def reviewed?
    reviewer.present? && reviewed_at.present?
  end
end
