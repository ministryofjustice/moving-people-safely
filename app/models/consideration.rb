class Consideration < ApplicationRecord
  include Considerations::CommonConcerns

  belongs_to :detainee

  after_initialize :configure_accessor_methods, :prepopulate

  def self.find_or_build(name:, detainee:)
    detainee.find_consideration_by_name(name) || build(name: name, detainee: detainee)
  end

  def self.build(name:, detainee: nil)
    new(name: name, detainee: detainee)
  end

  # override if needed
  def on?
    option == TERNARY_ON_VALUE if respond_to?(:option)
  end

  # override if necessary
  def values
    TERNARY_OPTIONS
  end

  # override if needed
  def toggle_choices
    TERNARY_OPTIONS
  end

  def validate
    @_errors = convert_errors_hash_to_active_record_errors(ActiveModel::Errors.new(self))
  end

  def valid?(context = nil)
    validate
    apply_schema.success?
  end

  def errors
    @_errors || ActiveModel::Errors.new(self)
  end

  def configure_accessor_methods
    attribute_names.each { |property| property_accessor(property) }
  end

  def attribute_names
    schema.rules.keys
  end

  def to_s
    name
  end

  private

  def convert_errors_hash_to_active_record_errors(ar_errors_obj)
    apply_schema.errors.each_with_object(ar_errors_obj) do |(key, values), obj|
      values.each { |val| obj.add(key, val) }
    end
  end

  def apply_schema
    reset
    schema.(properties)
  end

  # Override in subclasses if needed,
  # but call 'super' after your code so this is still exec'd
  def reset
    properties.reject! { |k, v| !attribute_names.include?(k.to_sym) }
  end

  def prepopulate
    # override if needed
  end

  def property_accessor(name)
    class_eval do
      define_method(name) { properties[name.to_s] }
      define_method("#{name}=") { |i| properties[name.to_s] = i }
    end
  end
end
