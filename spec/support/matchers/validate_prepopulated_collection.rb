RSpec::Matchers.define :validate_prepopulated_collection do |field_name|
  attr_reader :subject, :field_name

  match do |subject|
    @subject = subject
    @field_name = field_name

    # subject is a form object
    # field_name is the collection (as a symbol)

    has_ &&
      prepopulate! &&
      validate_collection &&
      handle_subform_deletion &&
      handle_collection_deletion

  end

  failure_message do
    "expected that #{field_name} would validate as a prepopulated collection"
  end

  description do
    "validate that :#{field_name} accepts nested form"
  end

  private

  def params
    {
      "#{field_name}" => [subform_params, subform_params],
      "has_#{field_name}" => 'yes'
    }
  end

  def reset_subject
    subject.public_send("#{field_name}=", [])
  end

  def handle_collection_deletion
    p2 = params
    p2["has_#{field_name}"] = 'no'
    subject.validate(p2)
    expect(subject.public_send(field_name)).to eql []
    reset_subject
  end

  def handle_subform_deletion
    p2 = params
    p2[field_name.to_s][0]['_delete'] = '1'
    subject.validate(p2)
    expect(subject.public_send(field_name).size).to eql 1
    reset_subject
  end

  def validate_collection
    subject.validate(params)
    expect(subject.public_send(field_name).size).to eql 2
    reset_subject
  end

  def subform_class
    namespace = subject.class.to_s.deconstantize
    const_name = [namespace, field_name.to_s.classify].join('::')
    const_name.constantize
  end

  def subform_model_class
    field_name.to_s.classify.constantize
  end

  def subform_params
    params = {}
    f = subform_class.new(subform_model_class.new)
    f.schema.each do |sch|
      options_hash = sch.instance_variable_get(:@options)
      name = options_hash[:name]
      type = options_hash[:type]

      case
      when name == 'carrier'
        params[name] = 'detainee'
      when type.to_s == "Forms::StrictString"
        params[name] = 'xxxxx'
      when name == '_delete'
        params[name] = '0'
      else
        raise "Undefined subform property type!"
      end
    end
    params
  end

  def has_
    has_method = "has_#{field_name}".to_sym
    subject.respond_to? has_method
    expect(subject.public_send(has_method)).to eql "unknown"
  end

  def prepopulate!
    expect(subject.public_send(field_name)).to eql []
    subject.prepopulate!
    expect(subject.public_send(field_name).size).to eql 1
    reset_subject
  end
end
