class ValidateOptionalField
  attr_reader :subject, :method_name, :error

  def initialize(method_name)
    @method_name = method_name
  end

  def matches?(subject)
    @subject = subject
    has_default_value && validates_inclusion
  end

  def description
    "validate that :#{method_name} behaves like an optional field."
  end

  def failure_message
    "Expected #{method_name} to behave like an optional field. \n#{error}"
  end

  private

  EXPECTED_DEFAULT_VALUE = 'unknown'

  def has_default_value
    default_value = subject.schema[method_name.to_s][:default].instance_variable_get("@value")
    result = default_value == EXPECTED_DEFAULT_VALUE

    unless result
      set_error "Attribute had a default value of #{default_value} instead of #{EXPECTED_DEFAULT_VALUE}."
    end

    result
  end

  FIELD_OPTIONS = %w[ yes no unknown ]

  def validates_inclusion
    result = Shoulda::Matchers::ActiveModel::ValidateInclusionOfMatcher.
      new(method_name).
      in_array(FIELD_OPTIONS).
      matches?(subject)

    unless result
      set_error "Attribute did not validate inclusion in #{FIELD_OPTIONS.to_sentence}."
    end

    result
  end

  def set_error(msg)
    @error = msg
  end
end
