class Offences < ApplicationRecord
  belongs_to :detainee
  has_many :current_offences, dependent: :destroy

  delegate :not_started?, :needs_review?, :incomplete?, :unconfirmed?, :confirmed?, to: :offences_workflow

  StatusChangeError = Class.new(StandardError)

  def all_questions_answered?
    current_offences.any?
  end

  def status
    offences_workflow&.status
  end

  def confirm!(user:)
    raise(StatusChangeError, :confirm_with_user!) unless offences_workflow
    offences_workflow.confirm_with_user!(user: user)
  end

  private

  def escort
    detainee&.escort
  end

  def move
    escort&.move
  end

  def offences_workflow
    move&.offences_workflow
  end
end
