class ValidateOptionalField
  attr_reader :subject, :method_name, :error

  def initialize(method_name)
    @method_name = method_name
  end

  def matches?(subject)
    @subject = subject
    validates_inclusion
  end

  def description
    "validate that :#{method_name} behaves like an optional field."
  end

  def failure_message
    "Expected #{method_name} to behave like an optional field. \n#{error}"
  end

  private

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
