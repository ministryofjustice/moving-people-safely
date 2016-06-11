RSpec::Matchers.define :nilify_empty_strings_for do |method_name|
  match do |subject|
    subject.public_send("#{method_name}=", '')
    subject.public_send(method_name).nil?
  end

  description do
    "return nil when an empty string is set for #{method_name}"
  end
end
