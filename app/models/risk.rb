class Risk < ApplicationRecord
  belongs_to :escort
  include Questionable
  act_as_assessment :risk

  StatusChangeError = Class.new(StandardError)

  delegate :not_started?, :needs_review?, :incomplete?, :unconfirmed?, :confirmed?, to: :risk_workflow

  def status
    risk_workflow&.status
  end

  def confirm!(user:)
    status_change(:confirm_with_user!, user: user)
  end

  def not_started!
    status_change(:not_started!)
  end

  def unconfirmed!
    status_change(:unconfirmed!)
  end

  def incomplete!
    status_change(:incomplete!)
  end

  private

  def move
    escort&.move
  end

  def risk_workflow
    move&.risk_workflow
  end

  def status_change(method, *args)
    raise(StatusChangeError, method) unless risk_workflow
    risk_workflow.public_send(method, *args)
  end
end
