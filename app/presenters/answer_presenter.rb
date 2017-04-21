class AnswerPresenter < SimpleDelegator
  def questions
    model.questions.map { |question| QuestionPresenter.new(question) }
  end

  private

  def model
    __getobj__
  end
end
