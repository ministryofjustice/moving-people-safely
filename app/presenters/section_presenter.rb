class SectionPresenter < SimpleDelegator
  def subsections
    @sections ||= model.subsections.map do |section|
      self.class.new(section)
    end
  end

  def questions
    @questions ||= model.questions.map do |question|
      QuestionPresenter.new(question)
    end
  end

  private

  def model
    __getobj__
  end
end
