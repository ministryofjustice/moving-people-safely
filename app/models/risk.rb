class Risk < ApplicationRecord
  belongs_to :detainee
  include Questionable

  class << self
    def schema
      @schema ||= Schemas::Assessment.new(ASSESSMENTS_SCHEMA['risk'])
    end

    def section_names
      schema.sections.map(&:name)
    end
  end

  StatusChangeError = Class.new(StandardError)

  delegate :not_started?, :needs_review?, :incomplete?, :unconfirmed?, :confirmed?, to: :risk_workflow

  def question_fields
    sections.map do |section|
      RiskAssessment.section_for(section.name).mandatory_questions
    end.flatten
  end

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

  def schema
    @schema ||= Schemas::Assessment.new(ASSESSMENTS_SCHEMA['risk'])
  end

  def sections
    @sections ||= schema.sections.map do |section_schema|
      Assessments::Section.new(self, section_schema)
    end
  end

  private

  def escort
    detainee&.escort
  end

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
