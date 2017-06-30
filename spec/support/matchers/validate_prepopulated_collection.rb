class ValidatePrepopulatedCollection
  attr_reader :subject, :field_name

  def initialize(field_name, options = {})
    @field_name = field_name
    @subform_class = options[:subform_class]
  end

  def matches?(subject)
    @subject = subject

    has_ &&
      prepopulate! &&
      validate_collection &&
      handle_subform_deletion &&
      handle_collection_deletion
  end

  def failure_message
    msg = "Expected that #{field_name} would validate as a prepopulated collection.\n"
    msg << @error if @error.present?
    msg
  end

  def description
    "validate that :#{field_name} accepts nested form."
  end

  private

  def has_
    result = subject.respond_to?("has_#{field_name}".to_sym)
    unless result == true
      set_error "Expected that #{subject.class.to_s} would implement has_#{field_name}, but it doesn't."
      return false
    end
    true
  end

  def prepopulate!
    unless collection == []
      set_error "Expected #{field_name} to default to [], got #{collection}"
      return false
    end
    subject.prepopulate!
    unless collection.size == 1
      set_error "Expected #prepopulate! method to add a #{subform_model_class.to_s} to the #{field_name} collection, got #{collection} instead."
      return false
    end
    reset_subject
  end

  def validate_collection
    subject.validate(params)
    unless collection.size == 2
      set_error "Failed to validate multiple nested #{field_name}. Got #{collection}"
      return false
    end
    reset_subject
  end

  def handle_subform_deletion
    p2 = params
    p2[field_name.to_s][0]['_delete'] = '1'
    subject.validate(p2)
    unless collection.size == 1
      set_error "Error handling nested model deletion. Received #{collection}."
      return false
    end
    reset_subject
  end

  def handle_collection_deletion
    unless has_defined_at_runtime?
      p2 = params
      p2["has_#{field_name}"] = 'no'
      subject.validate(p2)
      unless collection == []
        set_error "Error handling form validation when nested collection should be empty. Received #{collection}"
        return false
      end
    end
    reset_subject
  end

  # if the has_* method was defined at run-time, our form has different behaviour
  def has_defined_at_runtime?
    subject.public_send("has_#{field_name}") == 'yes'
  end

  def params
    {
      "#{field_name}" => [subform_params, subform_params],
      "has_#{field_name}" => 'yes'
    }
  end

  def reset_subject
    subject.public_send("#{field_name}=", [])
    true
  end

  def subform_class
    return @subform_class if @subform_class.present?
    namespace = subject.class.to_s.deconstantize
    const_name = [namespace, field_name.to_s.classify].join('::')
    @subform_class = const_name.constantize
  end

  def subform_model_class
    field_name.to_s.classify.constantize
  end

  # attempt to generate workable params for the collection model
  def subform_params
    factory_id = subform_model_class.to_s.underscore.to_sym
    params = FactoryGirl.attributes_for(factory_id).stringify_keys
    f = subform_class.new(subform_model_class.new)
    form_attrs = f.schema.keys
    params.select { |param| form_attrs.include?(param) }
  end

  def set_error(msg)
    @error = msg
  end

  def collection
    subject.public_send(field_name)
  end
end
