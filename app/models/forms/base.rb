require 'reform/form/coercion'

module Forms
  class Base < Reform::Form
    include Coercion

    TOGGLE_YES = 'yes'
    TOGGLE_NO = 'no'
    DEFAULT_CHOICE = 'unknown'
    TOGGLE_CHOICES = [TOGGLE_YES, TOGGLE_NO, DEFAULT_CHOICE].freeze

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

      # checks class instance methods
      def respond_to?(method_name)
        instance_methods.include?(method_name)
      end

      def optional_field(field_name)
        _define_attribute_is_on(field_name, TOGGLE_YES)
        property(field_name, type: String)
        validates field_name,
          inclusion: { in: TOGGLE_CHOICES },
          allow_blank: true
      end

      def optional_details_field(field_name)
        optional_field(field_name)
        property("#{field_name}_details", type: StrictString)
        validates "#{field_name}_details",
          presence: true,
          if: -> { public_send(field_name) == TOGGLE_YES }
      end

      def optional_checkbox(field_name, toggle = nil)
        _define_attribute_is_on(field_name, true)
        property field_name, type: Axiom::Types::Boolean, default: false
        property "#{field_name}_details", type: StrictString
        validates "#{field_name}_details",
          presence: true,
          if:
            -> { public_send(field_name) && public_send(toggle) == TOGGLE_YES }
      end

      def singularize(field_name)
        field_name.to_s.singularize
      end

      def _define_attribute_is_on(field_name, on_attr)
        define_method "#{field_name}_on?" do
          public_send(field_name) == on_attr
        end
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

      def prepopulated_collection(field_name)
        namespace = self.to_s.deconstantize
        const_name = [namespace, field_name.to_s.classify].join('::')

        collection field_name,
          form: const_name.constantize,
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
  end
end
