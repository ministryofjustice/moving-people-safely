module Considerable
  extend ActiveSupport::Concern

  included do
    def children_of(field, recursive: false)
      unless recursive
        public_send("#{field}_children")
      else
        if respond_to?("#{field}_children")
          children = public_send("#{field}_children")
          children.reduce(children.dup) do |acc, sub_child|
            acc.concat children_of(sub_child, recursive: true)
          end
        else
          []
        end
      end
    end

    def on_values_for(**fields)
      fields.each_with_object({}) { |field, obj| obj[field] = public_send "#{field}_on_values" }
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
      existance_query_method = "is_#{field}_a_branch?"
      possible_values_method = "#{field}_possible_values"
      on_values_method = "#{field}_on_values"
      branch_enabled_method = "#{field}_on?"
      child_fields_method = "#{field}_children"

      define_method child_fields_method do
        child_fields
      end

      define_method existance_query_method do
        true
      end

      define_method possible_values_method do
        values
      end

      define_method on_values_method do
        on_values
      end

      define_method branch_enabled_method do
        public_send(on_values_method).include? public_send(field)
      end

      field
    end

    def details_field(field, options = {})
      field
    end

    # TODO: standard options business
    def boolean_and_details_field(field)
      options = get_type_options :boolean, field
      options[:child_fields] = [ details_field(:"#{field}_details") ]
      branch field, **options.slice(:values, :on_values, :child_fields)
    end

    def values_and_details_field(field, options = {})
      type_options = get_type_options options.fetch(:type), field
      options.merge! type_options
      branch field, **options.slice(:values, :on_values, :child_fields)
    end

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
      ternary_type_options(field).merge(child_fields: [ details_field(:"#{field}_details") ])
    end
  end
end
