class ValidateOptionalDetailsField
  attr_reader :method_name, :details_field_method_name, :error

  def initialize(method_name)
    @method_name = method_name
    @details_field_method_name = "#{method_name}_details"
  end

  def matches?(original_subject)
    @original_subject = original_subject

    %i[
        validate_optional_field
        validates_presence_of_details_when_option_field_positive
        details_field_nilifies_empty_strings
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
    @subject = @original_subject.class.new(@original_subject.model)
  end

  def validate_optional_field
    validator = ValidateOptionalField.new(method_name)
    result = validator.matches?(subject)

    set_error validator.error unless result

    result
  end

  PresenceMatcher = Shoulda::Matchers::ActiveModel::ValidatePresenceOfMatcher

  def validate_presence_of_details_field
    subject.public_send("#{method_name}=", 'yes')

    validator = PresenceMatcher.new(details_field_method_name)
    result = validator.matches?(subject)

    set_error validator.failure_message unless result

    result
  end

  def details_field_nilifies_empty_strings
    subject.public_send("#{details_field_method_name}=", '')
    result = subject.public_send(details_field_method_name).nil?

    unless result
      set_error "Attribute #{details_field_method_name} should not be able to be set as an empty string."
    end

    result
  end

  def set_error(msg)
    @error = msg
  end
end
