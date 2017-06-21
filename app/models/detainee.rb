class Detainee < ApplicationRecord
  belongs_to :escort
  has_many :offences, dependent: :destroy
  has_one :offences_workflow

  before_create :set_defaults

  def set_defaults
    offences_workflow || build_offences_workflow
  end

  def offences
    OffencesCollection.new(workflow: offences_workflow, collection: super)
  end

  def age
    AgeCalculator.age(date_of_birth)
  end

  class OffencesCollection < SimpleDelegator
    def initialize(workflow:, collection:)
      @workflow = workflow
      super(collection)
    end

    attr_reader :workflow

    delegate(*OffencesWorkflow::DELEGATED_METHODS, to: :workflow)
  end
end
