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

    class << self
      def name
        super.demodulize.underscore
      end

      def optional_field(field_name)
        property(field_name, type: StrictString, default: DEFAULT_CHOICE)
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

      def optional_checkbox(field_name)
        property field_name, type: Axiom::Types::Boolean, default: false
        property "#{field_name}_details", type: StrictString
      end
    end

    def invalid?
      !valid?
    end

    def toggle_choices
      TOGGLE_CHOICES
    end
  end
end
