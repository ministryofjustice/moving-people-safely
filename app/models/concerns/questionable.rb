module Questionable
  def all_questions_answered?
    questions_not_answered.zero?
  end

  def no_questions_answered?
    questions_not_answered == question_fields.size
  end

  def questions_answered_yes
    question_fields.count do |question|
      %w[yes high].include?(public_send(question))
    end
  end

  def questions_answered_no
    question_fields.count { |question| public_send(question) == 'no' }
  end

  def questions_not_answered
    # THIS IS NOT RIGHT: 'unknown' shouldn't be considered to be an answer
    # that represents not been anwered, the value either has been selected or not
    # if it hasn't, it hasn't been answered.
    # For now and to keep it compatible with the current version I'll leave
    # the support for this, but this needs to be addressed, eventually
    question_fields.count { |question| public_send(question).blank? || public_send(question) == 'unknown' }
  end
end
