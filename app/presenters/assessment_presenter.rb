class AssessmentPresenter < SimpleDelegator
  def initialize(assessment, step)
    @step = step
    super(assessment)
  end

  def sections
    @sections ||= (step_schema&.subsections || []).map do |section|
      SectionPresenter.new(section)
    end
  end

  def questions
    @questions ||= (step_schema&.questions || []).map do |question|
      QuestionPresenter.new(question)
    end
  end

  private

  attr_reader :step

  def step_schema
    model.schema.for_section(step)
  end

  def model
    __getobj__
  end
end
