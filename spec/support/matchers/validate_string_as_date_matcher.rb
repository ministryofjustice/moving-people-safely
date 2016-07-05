RSpec::Matchers.define :validate_string_as_date do |method_name|
  match do |subject|
    resolves_as_date(subject, method_name) &&
      sets_error(subject, method_name)
  end

  failure_message do
    "expected that #{method_name} would validate a string in UK date format"
  end

  description do
    "validate that :#{method_name} accepts a string in UK date format"
  end

  private

  def resolves_as_date(subject, method_name)
    subject.public_send("#{method_name}=", '15/09/2027')
    subject.public_send(method_name) == Date.new(2027, 9, 15)
  end

  def sets_error(subject, method_name)
    subject.public_send("#{method_name}=", 'invalid')
    !subject.valid?
  end
end
