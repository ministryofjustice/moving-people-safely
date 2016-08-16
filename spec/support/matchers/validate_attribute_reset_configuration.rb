class ValidateAttributeResetConfiguration
  # Example usage:
  # expect(subject).to be_configured_to_reset(%i[ x y ]).when(:foo).not_set_to('yes')
  def initialize(attributes)
    @attributes = attributes
  end

  def matches?(subject)
    @subject = subject

    has_configuration &&
      configured_to_correct_master_attribute &&
      configured_to_reset_on_correct_value
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

  def matching_reset_data_obj
    @matching_reset_data_obj ||=
      resettable_attributes.find { |i| (attributes - i.attributes_to_reset).empty? }
  end

  def has_configuration
    matching_reset_data_obj ||
      set_error('No matching ResetData object found in the collection of resettable attributes.')
  end

  def configured_to_correct_master_attribute
    value = matching_reset_data_obj.master_attribute

    (value == master_attribute) ||
      set_error("No matching master attribute found in the ResetData object. " +
                "Expected: #{master_attribute} got: #{value}.")
  end

  def configured_to_reset_on_correct_value
    value = matching_reset_data_obj.enabled_value

    (value == master_attribute_on_value) ||
      set_error("No matching enabled value found in the ResetData object. " +
                 "Expected: #{master_attribute_on_value} got: #{value}.")
  end

  def set_error(msg)
    @error = msg

    false
  end
end
