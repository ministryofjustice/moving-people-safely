module Questionable
  def all_questions_answered?
    @all_questions_answered ||=
      self.class::MANDATORY_QUESTIONS.all? { |question| public_send(question).present? }
  end

  def question_relevant?(question)
    relevant_questions.include? question
  end

  def section_relevant?(questions)
    questions.any? { |question| relevant_questions.include? question }
  end
end
