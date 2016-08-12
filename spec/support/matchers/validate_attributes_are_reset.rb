class ValidateAttributesAreReset
  attr_reader :attributes, :toggle_attribute, :subject,
    :error, :attribute_value

  def initialize(*attributes)
    @attributes = attributes
    @attribute_value = "some user input"
  end

  def matches?(subject)
    @subject = subject

    validate_attributes_retained_when_toggle_attribute_is_yes &&
      validate_attributes_reset_when_toggle_attribute_is("no") &&
      validate_attributes_reset_when_toggle_attribute_is("unknown")
  end

  def when_attribute_is_disabled(attribute)
    @toggle_attribute = attribute
    self
  end

  def with_attribute_value_set_as(value)
    @attribute_value = value
    self
  end

  def description
    "validate that #{attributes.to_sentence} are reset when #{toggle_attribute} is disabled."
  end

  def failure_message
    "Expected #{attributes.to_sentence} to be reset when #{toggle_attribute} is disabled.\n#{error}"
  end

  private

  def validate_attributes_retained_when_toggle_attribute_is_yes
    populate_attributes_under_test
    set_toggle_attribute_to "yes"
    simulate_form_being_validated

    attributes.all? do |attr|
      result = subject.public_send(attr) == attribute_value

      unless result
        set_error "Expected #{attr} to be retained when #{toggle_attribute} set to yes"
      end

      result
    end
  end

  def validate_attributes_reset_when_toggle_attribute_is(value)
    populate_attributes_under_test
    set_toggle_attribute_to value
    simulate_form_being_validated

    attributes.all? do |attr|
      result = subject.public_send(attr).nil?

      unless result
        set_error "Expected #{attr} to be reset when #{toggle_attribute} set to #{value}"
      end

      result
    end
  end

  def populate_attributes_under_test
    attributes.each { |attr| subject.public_send("#{attr}=", attribute_value) }
  end

  def set_toggle_attribute_to(value)
    subject.public_send("#{toggle_attribute}=", value)
  end

  def simulate_form_being_validated
    fake_web_params = {}
    subject.validate(fake_web_params)
  end

  def set_error(msg)
    @error = msg
  end
end
