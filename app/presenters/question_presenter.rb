class QuestionPresenter < SimpleDelegator
  DISPLAY_TYPE_MAPPING = {
    'group' => 'fieldset',
    'boolean' => 'checkbox',
    'complex' => 'fields_for',
    'date' => 'text_field'
  }.freeze

  def subquestions
    @subquestions ||= model.subquestions.map { |question| QuestionPresenter.new(question) }
  end

  def answers_options
    return [] if answers.empty?
    answers.map(&:value)
  end

  def conditional_questions
    answers.map(&:questions).flatten.compact
  end

  def display_type
    return map_for_type if map_for_type

    if answers.present?
      'radio_button'
    elsif type == 'string' && name =~ /_details$/
      'text_area'
    elsif type == 'string'
      'text_field'
    end
  end

  def display_inline?
    answers.any? { |a| a.value == 'unknown' }
  end

  def toggle_field
    answers.find { |a| a.questions.any? }&.value
  end

  private

  def map_for_type
    @map_for_type ||= DISPLAY_TYPE_MAPPING[type]
  end

  def answers
    @answers ||= model.answers.map { |answer| AnswerPresenter.new(answer) }
  end

  def model
    __getobj__
  end
end
