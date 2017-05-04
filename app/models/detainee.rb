class Detainee < ApplicationRecord
  belongs_to :escort
  has_many :offences, dependent: :destroy

  def offences
    OffencesCollection.new(workflow: offences_workflow, collection: super)
  end

  def age
    AgeCalculator.age(date_of_birth)
  end

  def each_alias
    return [] unless aliases.present?
    aliases.split(',').each { |a| yield a }
  end

  private

  def offences_workflow
    escort&.move&.offences_workflow
  end

  class OffencesCollection < SimpleDelegator
    def initialize(workflow:, collection:)
      @workflow = workflow
      super(collection)
    end

    def all_questions_answered?
      __getobj__.any?
    end

    attr_reader :workflow

    delegate :not_started?, :needs_review?, :incomplete?, :unconfirmed?, :confirmed?, to: :workflow

    StatusChangeError = Class.new(StandardError)

    def status
      workflow&.status
    end

    def confirm!(user:)
      raise(StatusChangeError, :confirm_with_user!) unless workflow
      workflow.confirm_with_user!(user: user)
    end
  end
end
