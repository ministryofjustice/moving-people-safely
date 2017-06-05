class QuestionPresenter < SimpleDelegator
  DISPLAY_TYPE_MAPPING = {
    'group' => 'fieldset',
    'boolean' => 'checkbox',
    'complex' => 'fields_for',
    'date' => 'text_field'
  }.freeze

  def name
    question_name
  end

  def display_type
    return map_for_type if map_for_type

    if answer_options.present?
      'radio_button'
    elsif type == 'string' && name =~ /_details$/
      'text_area'
    elsif type == 'string'
      'text_field'
    end
  end

  def display_inline?
    answer_options.any? { |a| a.value == 'unknown' }
  end

  def toggle_field
    answer_options.find { |a| a.questions.any? }&.value
  end

  private

  def map_for_type
    @map_for_type ||= DISPLAY_TYPE_MAPPING[type]
  end

  def model
    __getobj__
  end
end
