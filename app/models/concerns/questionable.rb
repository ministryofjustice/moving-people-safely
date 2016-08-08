module Questionable
  def all_questions_answered?
    questions_not_answered == 0
  end

  def no_questions_answered?
    questions_not_answered == question_fields.size
  end

  def questions_answered_yes
    question_fields.count do |question|
      %w[ yes high ].include?(public_send(question))
    end
  end

  def questions_answered_no
    question_fields.count { |question| public_send(question) == 'no' }
  end

  def questions_not_answered
    question_fields.count { |question| public_send(question) == 'unknown' }
  end
end
