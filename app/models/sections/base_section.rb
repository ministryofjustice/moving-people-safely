class BaseSection
  def question_is_conditional?(question)
    !question_condition(question).nil?
  end

  def question_condition(question)
    question_dependencies.select { |_scope, dependencies| dependencies.include?(question.to_sym) }.keys.first
  end

  def question_has_details?(question)
    !question_details(question).nil?
  end

  def question_details(question)
    questions_details[question.to_sym]
  end

  def subsections
    subsections_questions.keys
  end

  def has_subsections?
    !subsections_questions.empty?
  end

  def questions_for_subsection(subsection)
    subsections_questions.fetch(subsection.to_sym, [])
  end

  private

  def question_dependencies
    {}
  end

  def questions_details
    {}
  end

  def subsections_questions
    {}
  end
end
