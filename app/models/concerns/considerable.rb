module Considerable
  extend ActiveSupport::Concern

  included do
    def on_values_for(fields)
      fields = *fields
      fields.each_with_object({}) do |field, obj|
        method = self.class.send(:on_values_method, field)
        obj[field] = self.class.send(method)
      end
    end
  end

  class_methods do
    def considerations
      @considerations
    end

    def consideration(field, options)
      @considerations ||= []
      @considerations << field

      type_options = get_type_options options.fetch(:type), field

      options.merge!(type_options)

      branch field, **options.slice(:values, :on_values, :child_fields)
    end

    def branch(field, values:, on_values:, child_fields: [])
      define_singleton_method "#{field}_children" do
        child_fields
      end

      define_method "#{field}_on?" do
        method = self.class.send(:on_values_method, field)
        self.class.send(method).include? public_send(field)
      end

      define_on_values_method(field, on_values)
      define_all_values_method(field, values)

      field
    end

    def children_of(field, recursive: false)
      if recursive
        if respond_to?("#{field}_children")
          children = public_send("#{field}_children")
          children.reduce(children.dup) do |acc, sub_child|
            acc.concat children_of(sub_child, recursive: true)
          end
        else
          []
        end
      else
        public_send("#{field}_children")
      end
    end

    def details_field(field, options = {})
      values = options.fetch(:values, nil)
      define_all_values_method(field, values) if values
      field
    end

    def boolean_and_details_field(field)
      options = get_type_options :boolean, field
      options[:child_fields] = [details_field(:"#{field}_details")]
      branch field, **options.slice(:values, :on_values, :child_fields)
    end

    def values_and_details_field(field, options = {})
      type_options = get_type_options options.fetch(:type), field
      options.merge! type_options
      branch field, **options.slice(:values, :on_values, :child_fields)
    end

    private

    def get_type_options(type, field)
      send("#{type}_type_options", field)
    end

    def boolean_type_options(_field)
      { values: [true, false], on_values: [true] }
    end

    def ternary_type_options(_field)
      { values: %w[ yes no unknown ], on_values: %w[ yes ] }
    end

    def ternary_and_details_field_type_options(field)
      ternary_type_options(field).merge(child_fields: [details_field(:"#{field}_details")])
    end

    def on_values_method(field)
      "#{field}_on_values"
    end

    def define_on_values_method(field, on_values)
      define_method on_values_method(field) do
        on_values
      end
      define_singleton_method on_values_method(field) do
        on_values
      end
    end

    def define_all_values_method(field, values)
      all_values_method = "#{field}_all_values"
      define_method all_values_method do
        values
      end
      define_singleton_method all_values_method do
        values
      end
    end
  end
end
