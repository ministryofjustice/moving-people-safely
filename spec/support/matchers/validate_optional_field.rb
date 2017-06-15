class ValidateOptionalField
  attr_reader :subject, :method_name, :inclusion, :error

  def initialize(method_name, options = {})
    @method_name = method_name
    @inclusion = options[:inclusion]
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

  FIELD_OPTIONS = %w[ yes no ]

  def validates_inclusion
    in_values = FIELD_OPTIONS
    in_values = inclusion[:in] if inclusion.present? && inclusion[:in].present?
    result = Shoulda::Matchers::ActiveModel::ValidateInclusionOfMatcher.
      new(method_name).
      in_array(in_values).
      matches?(subject)

    unless result
      set_error "Attribute value was not included in: #{in_values.to_sentence}."
    end

    result
  end

  def set_error(msg)
    @error = msg
  end
end
