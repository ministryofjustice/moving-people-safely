# frozen_string_literal: true

require 'reform/form/coercion'

module Forms
  class Base < Reform::Form
    include Coercion

    TOGGLE_YES = 'yes'
    TOGGLE_NO = 'no'
    TOGGLE_CHOICES = [TOGGLE_YES, TOGGLE_NO].freeze

    StrictString = Forms::StrictString
    TextDate = Forms::TextDate

    concerning :ResetAttributes do
      included do
        class << self
          def reset(attributes:, if_falsey:, enabled_value: TOGGLE_YES)
            resettable_attributes.add(attributes, if_falsey, enabled_value)
          end

          def resettable_attributes
            @_resettable_attributes ||= Forms::AttributeResetCollection.new
          end
        end

        def validate(*)
          super.tap do |valid|
            if valid && self.class.resettable_attributes.any?
              self.class.resettable_attributes.reset_all(self, default_attribute_values)
            end
          end
        end

        def default_attribute_values
          model.class.column_defaults
        end
      end
    end

    class << self
      def name
        super.demodulize.underscore
      end

      def properties
        definitions.keys
      end

      # checks class instance methods
      def respond_to?(method_name)
        instance_methods.include?(method_name)
      end

      def options_field(field_name, options = {})
        property_options = { type: options.fetch(:type, StrictString), default: options[:default] }
        property(field_name, property_options)

        validates field_name,
          inclusion: { in: options.fetch(:options, TOGGLE_CHOICES) },
          if: options.fetch(:if, -> { true }),
          allow_blank: options.fetch(:allow_blank, false)
      end

      def options_field_with_details(field_name, options = {})
        options_field(field_name, options)
        property("#{field_name}_details", type: StrictString)
        validates "#{field_name}_details",
          presence: true,
          if: -> { public_send(field_name) == TOGGLE_YES },
          allow_blank: options.fetch(:allow_blank, false)
        reset attributes: ["#{field_name}_details"], if_falsey: field_name
      end

      def singularize(field_name)
        field_name.to_s.singularize
      end

      def _define_add_singularized_field_name(field_name)
        singularized_field_name = singularize field_name
        define_method "add_#{singularized_field_name}" do
          new_instance = public_send("new_#{singularized_field_name}")
          public_send(field_name) << new_instance
        end
      end

      def _define_new_singularized_field_name(field_name)
        define_method "new_#{singularize field_name}" do
          model.public_send(field_name).build
        end
      end

      def _define_has_if_property_missing(field_name)
        unless respond_to?("has_#{field_name}".to_sym)
          define_method "has_#{field_name}" do
            'yes'
          end
        end
      end

      def _define_prepopulator(field_name)
        singularized_field_name = singularize field_name
        define_method "populate_#{field_name}" do |*|
          if public_send(field_name).empty?
            public_send("add_#{singularized_field_name}")
          end
        end
      end

      def _define_populator(field_name)
        singularized_field_name = singularize field_name
        define_method "handle_nested_params_for_#{field_name}" do |collection:, fragment:, **|
          item = collection.find { |d| ( d.id.present? && d.id == fragment['id']) }
          marked_to_be_deleted = fragment['_delete'] == '1'
          all_to_be_deleted = %w[ yes ].exclude?(
            public_send("has_#{field_name}")
          )

          if marked_to_be_deleted || all_to_be_deleted
            public_send(field_name).delete(item)
            return skip!
          end

          if item
            item
          else
            collection.append(public_send("new_#{singularized_field_name}"))
          end
        end
      end

      def prepopulated_collection(field_name, options = {})
        namespace = self.to_s.deconstantize
        const_name = [namespace, field_name.to_s.classify].join('::')

        collection field_name,
          form: options.fetch(:collection_form_class) { const_name.constantize },
          prepopulator: "populate_#{field_name}".to_sym,
          populator: "handle_nested_params_for_#{field_name}".to_sym

        _define_add_singularized_field_name(field_name)
        _define_new_singularized_field_name(field_name)
        _define_has_if_property_missing(field_name)
        _define_prepopulator(field_name)
        _define_populator(field_name)
      end
    end

    # instance methods

    def toggle_choices
      TOGGLE_CHOICES
    end

    def toggle_field
      TOGGLE_YES
    end

    def translate_options(options, section)
      options.map{ |option| I18n.t(option, scope: [:helpers, :label, section]) }
    end

    def name
      self.class.name
    end

    def model_class_name
      model.class.name.downcase
    end

    def from_prison?
      model.location == 'prison'
    end

    def from_police?
      model.location == 'police'
    end

    def female?
      model.escort.detainee_female?
    end

    def female_from_prison?
      from_prison? && female?
    end

    def female_from_police?
      from_police? && female?
    end
  end
end
