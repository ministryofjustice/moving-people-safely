class ValidateAttributeResetConfiguration
  # Example usage:
  # expect(subject).to be_configured_to_reset(%i[ x y ]).when(:foo).not_set_to('yes')
  def initialize(attributes)
    @attributes = attributes
  end

  def matches?(subject)
    @subject = subject

    has_configuration
  end

  attr_reader :subject, :attributes, :master_attribute, :master_attribute_on_value, :error

  def when(master_attribute)
    @master_attribute = master_attribute
    self
  end

  def not_set_to(master_attribute_on_value)
    @master_attribute_on_value = master_attribute_on_value
    self
  end

  def description
    "validate that :#{attributes.to_sentence} is configured for resetting."
  end

  def failure_message
    "Expected #{attributes.to_sentence} to be configured for resetting.\n#{error}"
  end

  private

  def resettable_attributes
    subject.class.resettable_attributes.collection
  end

  def has_configuration
    resettable_attributes.any? { |i| i.values == expected_as_tuple } || set_error(error_text)
  end

  def expected_as_tuple
    [attributes, master_attribute, master_attribute_on_value]
  end

  def error_text
    expected = %i[ attributes if_falsey enabled_value ].zip(expected_as_tuple).to_h
    "Failed to find #{expected}"
  end

  def set_error(msg)
    @error = msg
    false
  end
end
