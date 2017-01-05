class BaseSection
  def question_is_conditional?(question)
    !question_condition(question).nil?
  end

  def question_condition(question)
    question_dependencies.select { |_scope, dependencies| dependencies.include?(question.to_sym) }.keys.first
  end

  private

  def question_dependencies
    {}
  end
end
