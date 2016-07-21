class ValidateStrictString
  attr_reader :method_name

  def initialize(method_name)
    @method_name = method_name
  end

  def matches?(subject)
    subject.public_send("#{method_name}=", '')
    subject.public_send(method_name).nil?
  end

  def description
    "validate that :#{method_name} behaves like a StrictString."
  end

  def failure_message
    """
    Expected #{method_name} to behave like a StrictString.
    It should return nil instead of an empty string.
    """
  end
end
