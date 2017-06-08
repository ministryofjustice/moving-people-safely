class ValidateOptionalDetailsField
  attr_reader :method_name, :details_field_method_name, :error

  def initialize(method_name)
    @method_name = method_name
    @details_field_method_name = "#{method_name}_details"
  end

  def matches?(original_subject)
    @original_subject = original_subject

    %i[ validate_optional_field
        validates_presence_of_details_field_when_option_field_positive
        doesnt_validate_presence_of_details_field_when_option_field_negative
        validates_details_field_as_strict_string
        validates_details_field_is_configured_to_be_reset
    ].map { |assertion_name| reset_subject && send(assertion_name) }.all?
  end

  def description
    "validate that :#{method_name} behaves like an optional details field."
  end

  def failure_message
    "Expected #{method_name} to behave like an optional details field. \n#{error}"
  end

  private

  def subject
    @subject
  end

  def reset_subject
    # We need a fresh subject as Reform maintains errors across validations
    @subject = @original_subject.class.new(@original_subject.model)
  end

  def validate_optional_field
    validator = ValidateOptionalField.new(method_name)
    result = validator.matches?(subject)

    set_error validator.error unless result

    result
  end

  PresenceMatcher = Shoulda::Matchers::ActiveModel::ValidatePresenceOfMatcher

  def perform_presence_validation_on_details_field(option_field_value:)
    subject.public_send("#{method_name}=", option_field_value)
    subject.public_send("#{details_field_method_name}=", nil)
    PresenceMatcher.new(details_field_method_name).matches?(subject)
  end

  def validates_presence_of_details_field_when_option_field_positive
    result = perform_presence_validation_on_details_field(option_field_value: 'yes')

    unless result
      set_error "Should not be able to set #{details_field_method_name} value to nil/empty string when the option field is set to: yes"
    end

    result
  end

  def doesnt_validate_presence_of_details_field_when_option_field_negative
    reset_subject

    result = !perform_presence_validation_on_details_field(option_field_value: option_field_value)

    unless result
      set_error "Should be acceptable to set #{details_field_method_name} value to nil/empty string when the option field is set to: #{option_field_value}."
    end

    result
  end

  def validates_details_field_as_strict_string
    validator = ValidateStrictString.new(details_field_method_name)
    result = validator.matches?(subject)

    set_error validator.failure_message unless result

    result
  end

  def validates_details_field_is_configured_to_be_reset
    validator = ValidateAttributeResetConfiguration.
      new([details_field_method_name]).
      when(method_name).
      not_set_to('yes')

    result = validator.matches?(subject)

    set_error validator.failure_message unless result

    result
  end

  def set_error(msg)
    @error = msg
  end
end
